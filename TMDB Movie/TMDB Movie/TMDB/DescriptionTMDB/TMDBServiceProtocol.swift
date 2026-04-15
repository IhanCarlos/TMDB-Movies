//
//  TMDBServiceProtocol.swift
//  TMDB Movie
//
//  Created by Arthur Ferreira on 09/01/26.
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
    func tvDetail(id: Int) async throws -> TMDBTVDetailDTO

    func movieCredits(id: Int) async throws -> [TMDBCastDTO]
    func tvCredits(id: Int) async throws -> [TMDBCastDTO]

    func movieRecommendations(id: Int, page: Int) async throws -> [TMDBMovieDTO]
    func tvRecommendations(id: Int, page: Int) async throws -> [TMDBTVDTO]
}
