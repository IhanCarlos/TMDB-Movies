//
//  AppCoordinator.swift
//  TMDB Movie
//
//  Created by ihan carlos on 09/01/26.
//

import UIKit

final class AppCoordinator: Coordinator {

    let navigationController: UINavigationController

    private let service: TMDBServiceProtocol
    private let imageLoader: ImageLoaderProtocol

    private var childCoordinators: [Coordinator] = []

    init(
        navigationController: UINavigationController,
        service: TMDBServiceProtocol,
        imageLoader: ImageLoaderProtocol
    ) {
        self.navigationController = navigationController
        self.service = service
        self.imageLoader = imageLoader
    }

    func start() {
        Task { @MainActor in
            self.showLogin()
        }
    }

    @MainActor
    private func showLogin() {
        let coordinator = LoginCoordinator(
            navigationController: navigationController,
            service: service,
            imageLoader: imageLoader
        )

        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let self else { return }

            if let coordinator {
                self.childCoordinators.removeAll { $0 === coordinator }
            }

            Task { @MainActor in
                self.showHome()
            }
        }

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    @MainActor
    private func showHome() {
        let coordinator = HomeCoordinator(
            navigationController: navigationController,
            service: service,
            imageLoader: imageLoader
        )

        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
