//
//  APIError.swift
//  TMDB Movie
//
//  Created by ihan carlos on 08/01/26.
//

import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case httpStatus(Int, Data?)
    case decoding
    case cancelled
}
