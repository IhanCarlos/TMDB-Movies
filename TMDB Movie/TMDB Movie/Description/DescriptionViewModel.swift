//
//  DescriptionViewModel.swift
//  TMDB Movie
//
//  Created by ihan carlos on 09/01/26.
//

import Foundation

@MainActor
final class DescriptionViewModel {

    enum State {
        case idle
        case loading
        case loaded(Output)
        case error(String)
    }

    struct Output {
        let viewModel: DescriptionView.ViewModel
        let backdropURL: URL?
        let trailerKey: String?
    }

    var onStateChange: ((State) -> Void)?

    private let service: TMDBServiceProtocol
    private let movieId: Int

    private var task: Task<Void, Never>?

    init(service: TMDBServiceProtocol, movieId: Int) {
        self.service = service
        self.movieId = movieId
    }

    func load() {
        task?.cancel()
        onStateChange?(.loading)

        task = Task { [weak self] in
            guard let self else { return }

            do {
                async let detail = self.service.movieDetail(id: self.movieId)
                async let cast = self.service.movieCredits(id: self.movieId)
                async let recs = self.service.movieRecommendations(id: self.movieId, page: 1)
                async let videos = self.service.movieVideos(id: self.movieId)

                let (d, c, r, v) = try await (detail, cast, recs, videos)

                if Task.isCancelled { return }

                let output = self.makeOutput(
                    detail: d,
                    cast: c,
                    recs: r,
                    videos: v
                )

                self.onStateChange?(.loaded(output))
            } catch {
                if Task.isCancelled { return }
                self.onStateChange?(.error("Falha ao carregar"))
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }

    private func makeOutput(
        detail: TMDBMovieDetailDTO,
        cast: [TMDBCastDTO],
        recs: [TMDBMovieDTO],
        videos: [TMDBVideoDTO]
    ) -> Output {

        let title = detail.title
        let overview = detail.overview.isEmpty ? "Sem descrição disponível." : detail.overview

        let date = detail.releaseDate ?? ""
        let runtime = detail.runtime.map(formatRuntime) ?? ""
        let meta = [date, runtime].filter { !$0.isEmpty }.joined(separator: "  •  ")

        let ratingPercent = Int((detail.voteAverage * 10).rounded())

        let backdropURL = detail.backdropPath
            .flatMap { AppConfig.tmdbImageURL(path: $0, context: .heroBackdrop) }

        let castItems = cast.prefix(12).map(mapCast)
        let categories = detail.genres.map { $0.name }
        let recommendations = recs.prefix(12).map(mapMovie)

        let trailerKey = pickTrailerKey(from: videos)

        let viewModel = DescriptionView.ViewModel(
            header: .init(image: nil, isFavorite: false),
            summary: .init(
                ratingPercent: ratingPercent,
                title: title,
                meta: meta
            ),
            overview: overview,
            ctaTitle: trailerKey == nil ? "Trailer indisponível" : "Assistir trailer",
            cast: .init(title: "Elenco principal", items: castItems),
            categories: .init(title: "Categorias", chips: categories),
            recommendations: .init(title: "Recomendações", items: recommendations)
        )

        return Output(
            viewModel: viewModel,
            backdropURL: backdropURL,
            trailerKey: trailerKey
        )
    }

    private func mapCast(_ dto: TMDBCastDTO) -> CastItem {
        let url = dto.profilePath
            .flatMap { AppConfig.tmdbImageURL(path: $0, context: .castProfileLarge) }

        return CastItem(
            id: dto.id,
            name: dto.name,
            profileURL: url
        )
    }

    private func mapMovie(_ dto: TMDBMovieDTO) -> PosterItem {
        let url = dto.posterPath
            .flatMap { AppConfig.tmdbImageURL(path: $0, context: .posterGrid) }

        return PosterItem(
            id: dto.id,
            title: dto.title ?? "",
            posterURL: url
        )
    }

    private func pickTrailerKey(from videos: [TMDBVideoDTO]) -> String? {
        let youtube = videos.filter { $0.site.lowercased() == "youtube" }
        let trailer = youtube.first { $0.type.lowercased() == "trailer" }
        return trailer?.key ?? youtube.first?.key
    }

    private func formatRuntime(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        return h > 0 ? "\(h)h \(m)m" : "\(m)m"
    }
}
