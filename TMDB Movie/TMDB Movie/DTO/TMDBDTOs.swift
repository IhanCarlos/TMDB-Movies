//
//  TMDBDTOs.swift
//  TMDB Movie
//
//  Created by Arthur Ferreira on 08/01/26.
//

import Foundation

struct TMDBPagedResponseDTO<T: Decodable>: Decodable {
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int
}

struct TMDBMovieDTO: Decodable {
    let id: Int
    let title: String?
    let posterPath: String?
}
