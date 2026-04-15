//
//  TMDBGenre.swift
//  TMDB Movie
//
//  Created by Arthur Ferreira on 08/01/26.
//

struct TMDBGenre: Decodable, Equatable {
    let id: Int
    let name: String
}

struct TMDBGenreResponse: Decodable {
    let genres: [TMDBGenre]
}
