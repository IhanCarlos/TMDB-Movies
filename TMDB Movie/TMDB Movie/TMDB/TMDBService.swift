//
//  TMDBService.swift
//  TMDB Movie
//
//  Created by ihan carlos on 08/01/26.
//

import Foundation

protocol TMDBServiceProtocol {
    func popularMovies(page: Int) async throws -> [TMDBMovieDTO]
    func searchMovies(query: String, page: Int) async throws -> [TMDBMovieDTO]

    func popularTV(page: Int) async throws -> [TMDBTVDTO]
    func searchTV(query: String, page: Int) async throws -> [TMDBTVDTO]

    func movieGenres() async throws -> [TMDBGenre]
    func tvGenres() async throws -> [TMDBGenre]

    func discoverMovies(genreId: Int, page: Int) async throws -> [TMDBMovieDTO]
    func discoverTV(genreId: Int, page: Int) async throws -> [TMDBTVDTO]

    func trendingMoviesWeek(page: Int) async throws -> [TMDBMovieDTO]
    func trendingTVWeek(page: Int) async throws -> [TMDBTVDTO]

    func movieDetail(id: Int) async throws -> TMDBMovieDetailDTO
    func movieCredits(id: Int) async throws -> [TMDBCastDTO]
    func movieRecommendations(id: Int, page: Int) async throws -> [TMDBMovieDTO]
    func movieVideos(id: Int) async throws -> [TMDBVideoDTO]
}

final class TMDBService: TMDBServiceProtocol {

    private let client: APIClientProtocol

    init(client: APIClientProtocol) {
        self.client = client
    }

    func popularMovies(page: Int = 1) async throws -> [TMDBMovieDTO] {
        let endpoint = Endpoint(
            path: "movie/popular",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR"),
                .init(name: "page", value: "\(page)")
            ]
        )

        let response: TMDBPagedResponseDTO<TMDBMovieDTO> = try await client.send(endpoint)
        return response.results
    }

    func searchMovies(query: String, page: Int = 1) async throws -> [TMDBMovieDTO] {
        let endpoint = Endpoint(
            path: "search/movie",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR"),
                .init(name: "page", value: "\(page)"),
                .init(name: "query", value: query)
            ]
        )

        let response: TMDBPagedResponseDTO<TMDBMovieDTO> = try await client.send(endpoint)
        return response.results
    }

    func popularTV(page: Int = 1) async throws -> [TMDBTVDTO] {
        let endpoint = Endpoint(
            path: "tv/popular",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR"),
                .init(name: "page", value: "\(page)")
            ]
        )

        let response: TMDBPagedResponseDTO<TMDBTVDTO> = try await client.send(endpoint)
        return response.results
    }

    func searchTV(query: String, page: Int = 1) async throws -> [TMDBTVDTO] {
        let endpoint = Endpoint(
            path: "search/tv",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR"),
                .init(name: "page", value: "\(page)"),
                .init(name: "query", value: query)
            ]
        )

        let response: TMDBPagedResponseDTO<TMDBTVDTO> = try await client.send(endpoint)
        return response.results
    }

    func movieGenres() async throws -> [TMDBGenre] {
        let endpoint = Endpoint(
            path: "genre/movie/list",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR")
            ]
        )

        let response: TMDBGenreResponse = try await client.send(endpoint)
        return response.genres
    }

    func tvGenres() async throws -> [TMDBGenre] {
        let endpoint = Endpoint(
            path: "genre/tv/list",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR")
            ]
        )

        let response: TMDBGenreResponse = try await client.send(endpoint)
        return response.genres
    }

    func discoverMovies(genreId: Int, page: Int = 1) async throws -> [TMDBMovieDTO] {
        let endpoint = Endpoint(
            path: "discover/movie",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR"),
                .init(name: "with_genres", value: "\(genreId)"),
                .init(name: "page", value: "\(page)")
            ]
        )

        let response: TMDBPagedResponseDTO<TMDBMovieDTO> = try await client.send(endpoint)
        return response.results
    }

    func discoverTV(genreId: Int, page: Int = 1) async throws -> [TMDBTVDTO] {
        let endpoint = Endpoint(
            path: "discover/tv",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR"),
                .init(name: "with_genres", value: "\(genreId)"),
                .init(name: "page", value: "\(page)")
            ]
        )

        let response: TMDBPagedResponseDTO<TMDBTVDTO> = try await client.send(endpoint)
        return response.results
    }

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

    func movieCredits(id: Int) async throws -> [TMDBCastDTO] {
        let endpoint = Endpoint(
            path: "movie/\(id)/credits",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR")
            ]
        )
        let response: TMDBCreditsResponseDTO = try await client.send(endpoint)
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

    func movieVideos(id: Int) async throws -> [TMDBVideoDTO] {
        let endpoint = Endpoint(
            path: "movie/\(id)/videos",
            method: .get,
            queryItems: [
                .init(name: "language", value: "pt-BR")
            ]
        )
        let response: TMDBVideosResponseDTO = try await client.send(endpoint)
        return response.results
    }
}
