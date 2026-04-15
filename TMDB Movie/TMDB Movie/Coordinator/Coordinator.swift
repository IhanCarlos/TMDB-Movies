//
//  Coordinator.swift
//  TMDB Movie
//
//  Created by ihan carlos on 09/01/26.
//

import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}
