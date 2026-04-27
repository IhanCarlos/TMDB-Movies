//
//  LoginModel.swift
//  TMDB Movie
//
//  Created by ihan carlos on 16/04/26.
//

import Foundation

enum State: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}
