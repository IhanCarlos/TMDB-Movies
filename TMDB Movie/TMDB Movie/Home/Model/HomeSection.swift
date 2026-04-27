//
//  HomeSection.swift
//  TMDB Movie
//
//  Created by ihan carlos on 13/01/26.
//

import Foundation

enum HomeSectionType: Equatable {
    case trendingWeek
    case popular
    case genre(id: Int, name: String)
    case search(query: String)

    var title: String {
        switch self {
        case .trendingWeek: return "Em alta"
        case .popular: return "Populares"
        case .genre(_, let name): return name
        case .search: return "Resultados"
        }
    }

    var subtitle: String? {
        switch self {
        case .trendingWeek: return "Top 10 da semana"
        case .popular: return "O que todo mundo está assistindo"
        case .genre: return "Selecionados para você"
        case .search(let q): return "Buscando por: \(q)"
        }
    }
}

struct HomeSection: Equatable {
    let type: HomeSectionType
    let items: [PosterItem]
}
