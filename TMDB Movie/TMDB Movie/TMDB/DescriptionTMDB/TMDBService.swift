//
//  TMDBService.swift
//  TMDB Movie
//
//  Created by Arthur Ferreira on 09/01/26.
//

import Foundation

extension TMDBService {

    func trendingMoviesWeek(page: Int = 1) async throws -> [TMDBMovieDTO] {
        let endpoint = Endpoint(
            path: "trending/movie/week",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR"),
                .init(name: "page", value: "\(page)")
            ]
        )
        let response: TMDBPagedResponseDTO<TMDBMovieDTO> = try await client.send(endpoint)
        return response.results
    }

    func trendingTVWeek(page: Int = 1) async throws -> [TMDBTVDTO] {
        let endpoint = Endpoint(
            path: "trending/tv/week",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR"),
                .init(name: "page", value: "\(page)")
            ]
        )
        let response: TMDBPagedResponseDTO<TMDBTVDTO> = try await client.send(endpoint)
        return response.results
    }

    func movieDetail(id: Int) async throws -> TMDBMovieDetailDTO {
        let endpoint = Endpoint(
            path: "movie/\(id)",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR")
            ]
        )
        return try await client.send(endpoint)
    }

    func tvDetail(id: Int) async throws -> TMDBTVDetailDTO {
        let endpoint = Endpoint(
            path: "tv/\(id)",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR")
            ]
        )
        return try await client.send(endpoint)
    }

    func movieCredits(id: Int) async throws -> [TMDBCastDTO] {
        let endpoint = Endpoint(
            path: "movie/\(id)/credits",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR")
            ]
        )
        let response: TMDBCreditsDTO = try await client.send(endpoint)
        return response.cast
    }

    func tvCredits(id: Int) async throws -> [TMDBCastDTO] {
        let endpoint = Endpoint(
            path: "tv/\(id)/credits",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR")
            ]
        )
        let response: TMDBCreditsDTO = try await client.send(endpoint)
        return response.cast
    }

    func movieRecommendations(id: Int, page: Int = 1) async throws -> [TMDBMovieDTO] {
        let endpoint = Endpoint(
            path: "movie/\(id)/recommendations",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR"),
                .init(name: "page", value: "\(page)")
            ]
        )
        let response: TMDBPagedResponseDTO<TMDBMovieDTO> = try await client.send(endpoint)
        return response.results
    }

    func tvRecommendations(id: Int, page: Int = 1) async throws -> [TMDBTVDTO] {
        let endpoint = Endpoint(
            path: "tv/\(id)/recommendations",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR"),
                .init(name: "page", value: "\(page)")
            ]
        )
        let response: TMDBPagedResponseDTO<TMDBTVDTO> = try await client.send(endpoint)
        return response.results
    }
}
