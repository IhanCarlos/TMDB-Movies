//
//  TMDBSmokeTest.swift
//  TMDB Movie
//
//  Created by ihan carlos on 08/01/26.
//

import Foundation

final class TMDBSmokeTest {

    static func run() {
        Task {
            do {
                let client = APIClient(baseURL: AppConfig.tmdbBaseURL, bearerToken: AppConfig.tmdbBearerToken)

                let endpoint = Endpoint(
                    path: "movie/popular",
                    method: .get,
                    queryItems: [
                        .init(name: "language", value: "pt-BR"),
                        .init(name: "page", value: "1")
                    ]
                )

                let response: TMDBPagedResponseDTO<TMDBMovieDTO> = try await client.send(endpoint)
                print("Popular count:", response.results.count)
                print("First:", response.results.first?.title ?? "nil")
            } catch {
                print("TMDB error:", error)
            }
        }
    }
}
