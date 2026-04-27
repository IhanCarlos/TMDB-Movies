//
//  HomeViewModel.swift
//  TMDB Movie
//
//  Created by ihan carlos on 08/01/26.
//

import Foundation

@MainActor
final class HomeViewModel {

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    var onStateChange: ((State) -> Void)?
    var onGenresChange: (([TMDBGenre]) -> Void)?
    var onSectionsChange: (([HomeSection]) -> Void)?

    private let service: TMDBServiceProtocol
    private var task: Task<Void, Never>?

    private(set) var genres: [TMDBGenre] = [] {
        didSet { onGenresChange?(genres) }
    }

    private(set) var sections: [HomeSection] = [] {
        didSet { onSectionsChange?(sections) }
    }

    private var selectedGenre: TMDBGenre?

    init(service: TMDBServiceProtocol) {
        self.service = service
    }

    func loadInitial() {
        task?.cancel()
        onStateChange?(.loading)
        sections = [
            .init(type: .trendingWeek, items: []),
            .init(type: .popular, items: [])
        ]

        task = Task { [weak self] in
            guard let self else { return }
            do {
                async let genres = self.service.movieGenres()
                async let trending = self.service.trendingMoviesWeek(page: 1)
                async let popular = self.service.popularMovies(page: 1)

                let (g, t, p) = try await (genres, trending, popular)
                if Task.isCancelled { return }

                self.genres = g

                let top10Trending = Array(t.prefix(10)).map(self.mapMovie)
                let top12Popular  = Array(p.prefix(12)).map(self.mapMovie)

                let built: [HomeSection] = [
                    .init(type: .trendingWeek, items: top10Trending),
                    .init(type: .popular, items: top12Popular)
                ]

                self.sections = built
                self.onStateChange?(built.allSatisfy { $0.items.isEmpty } ? .empty : .loaded)
            } catch {
                if Task.isCancelled { return }
                self.onStateChange?(.error("Falha ao carregar"))
            }
        }
    }

    func selectGenre(index: Int) {
        task?.cancel()
        onStateChange?(.loading)

        if index == 0 {
            selectedGenre = nil
            loadInitial()
            return
        }

        let idx = index - 1
        guard genres.indices.contains(idx) else { return }
        selectedGenre = genres[idx]
        let genre = genres[idx]

        sections = [
            .init(type: .trendingWeek, items: []),
            .init(type: .popular, items: []),
            .init(type: .genre(id: genre.id, name: genre.name), items: [])
        ]

        task = Task { [weak self] in
            guard let self else { return }
            do {
                async let trending = self.service.trendingMoviesWeek(page: 1)
                async let popular  = self.service.popularMovies(page: 1)
                async let byGenre  = self.service.discoverMovies(genreId: genre.id, page: 1)

                let (t, p, g) = try await (trending, popular, byGenre)
                if Task.isCancelled { return }

                let built: [HomeSection] = [
                    .init(type: .trendingWeek, items: Array(t.prefix(10)).map(self.mapMovie)),
                    .init(type: .popular, items: Array(p.prefix(12)).map(self.mapMovie)),
                    .init(type: .genre(id: genre.id, name: genre.name), items: Array(g.prefix(12)).map(self.mapMovie))
                ]

                self.sections = built
                self.onStateChange?(built.allSatisfy { $0.items.isEmpty } ? .empty : .loaded)
            } catch {
                if Task.isCancelled { return }
                self.onStateChange?(.error("Falha ao carregar"))
            }
        }
    }

    func search(query: String) {
        task?.cancel()

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            if let selectedGenre, let idx = genres.firstIndex(of: selectedGenre) {
                selectGenre(index: idx + 1)
            } else {
                loadInitial()
            }
            return
        }

        onStateChange?(.loading)
        sections = [.init(type: .search(query: trimmed), items: [])]

        task = Task { [weak self] in
            guard let self else { return }
            do {
                let movies = try await self.service.searchMovies(query: trimmed, page: 1)
                if Task.isCancelled { return }

                let items = Array(movies.prefix(30)).map(self.mapMovie)
                self.sections = [.init(type: .search(query: trimmed), items: items)]
                self.onStateChange?(items.isEmpty ? .empty : .loaded)
            } catch {
                if Task.isCancelled { return }
                self.onStateChange?(.error("Falha ao buscar"))
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }

    private func mapMovie(_ dto: TMDBMovieDTO) -> PosterItem {
        let url = dto.posterPath.flatMap { AppConfig.tmdbImageURL(path: $0, size: .w342) }
        return PosterItem(id: dto.id, title: dto.title ?? "", posterURL: url)
    }
}
