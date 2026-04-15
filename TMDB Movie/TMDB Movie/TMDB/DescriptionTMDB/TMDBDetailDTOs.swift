//
//  TMDBDetailDTOs.swift
//  TMDB Movie
//
//  Created by Arthur Ferreira on 09/01/26.
//

import Foundation

struct TMDBMovieDetailDTO: Decodable {
    let id: Int
    let title: String?
    let overview: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double?
    let backdropPath: String?
    let genres: [TMDBGenre]?
}

struct TMDBTVDetailDTO: Decodable {
    let id: Int
    let name: String?
    let overview: String?
    let firstAirDate: String?
    let episodeRunTime: [Int]?
    let voteAverage: Double?
    let backdropPath: String?
    let genres: [TMDBGenre]?
}

struct TMDBCreditsDTO: Decodable {
    let cast: [TMDBCastDTO]
}

struct TMDBCastDTO: Decodable {
    let id: Int
    let name: String?
    let profilePath: String?
}
