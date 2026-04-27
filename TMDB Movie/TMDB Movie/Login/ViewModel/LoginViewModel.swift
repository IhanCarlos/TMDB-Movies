//
//  LoginViewModel.swift
//  TMDB Movie
//
//  Created by ihan carlos on 09/01/26.
//

import Foundation

@MainActor
final class LoginViewModel {

    var onStateChange: ((State) -> Void)?
    var onBackgroundURLsChange: (([URL]) -> Void)?

    private let service: TMDBServiceProtocol
    private var task: Task<Void, Never>?

    init(service: TMDBServiceProtocol) {
        self.service = service
    }

    func load() {
        task?.cancel()
        onStateChange?(.loading)

        task = Task { [weak self] in
            guard let self else { return }
            do {
                let movies = try await self.service.trendingMoviesWeek(page: 1)

                let urls: [URL] = movies
                    .compactMap { $0.backdropPath }
                    .prefix(10)
                    .compactMap { AppConfig.tmdbImageURL(path: $0, context: .loginBackdrop) }

                self.onBackgroundURLsChange?(urls)
                self.onStateChange?(urls.isEmpty ? .error("Sem imagens") : .loaded)
            } catch {
                self.onStateChange?(.error("Falha ao carregar"))
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}
