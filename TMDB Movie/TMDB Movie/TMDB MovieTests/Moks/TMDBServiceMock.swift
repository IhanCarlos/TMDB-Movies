//
//  TMDBServiceMock.swift
//  TMDB Movie
//
//  Created by ihan carlos on 20/04/26.
//

import Foundation
@testable import TMDB_Movie

final class TMDBServiceMock: TMDBServiceProtocol {
    
    var trendingMoviesError: Error?
    
    var trendingMoviesResult: [TMDBMovieDTO] = []
    var movieGenresResult: [TMDBGenre] = []
    var popularMoviesResult: [TMDBMovieDTO] = []
    var searchMoviesResult: [TMDBMovieDTO] = []
    var discoverMoviesResult: [TMDBMovieDTO] = []
    
    var discoverMoviesCalled = false
    var searchMoviesCalled = false
    var trendingMoviesCalled = false
    
    func movieGenres() async throws -> [TMDBGenre] {
        return movieGenresResult
    }
    
    func trendingMoviesWeek(page: Int) async throws -> [TMDBMovieDTO] {
        trendingMoviesCalled = true
        return trendingMoviesResult
    }
    
    func popularMovies(page: Int) async throws -> [TMDBMovieDTO] {
        return popularMoviesResult
    }
    
    func searchMovies(query: String, page: Int) async throws -> [TMDBMovieDTO] {
        searchMoviesCalled = true
        return searchMoviesResult
    }
    
    func discoverMovies(genreId: Int, page: Int) async throws -> [TMDBMovieDTO] {
        discoverMoviesCalled = true
        return discoverMoviesResult
    }
    
    func popularTV(page: Int) async throws -> [TMDBTVDTO] { [] }
    func searchTV(query: String, page: Int) async throws -> [TMDBTVDTO] { [] }
    func tvGenres() async throws -> [TMDBGenre] { [] }
    func discoverTV(genreId: Int, page: Int) async throws -> [TMDBTVDTO] { [] }
    func trendingTVWeek(page: Int) async throws -> [TMDBTVDTO] { [] }
    func movieDetail(id: Int) async throws -> TMDBMovieDetailDTO { fatalError("Não implementado") }
    func movieCredits(id: Int) async throws -> [TMDBCastDTO] { [] }
    func movieRecommendations(id: Int, page: Int) async throws -> [TMDBMovieDTO] { [] }
    func movieVideos(id: Int) async throws -> [TMDBVideoDTO] { [] }
}
