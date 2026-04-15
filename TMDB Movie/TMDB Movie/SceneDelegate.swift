//
//  SceneDelegate.swift
//  TMDB Movie
//
//  Created by ihan carlos on 30/12/25.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        let apiClient: APIClientProtocol = APIClient(
            baseURL: AppConfig.tmdbBaseURL,
            bearerToken: AppConfig.tmdbBearerToken
        )
        let service: TMDBServiceProtocol = TMDBService(client: apiClient)
        let imageLoader: ImageLoaderProtocol = ImageLoader(client: apiClient)

        let nav = UINavigationController()

        let appCoordinator = AppCoordinator(
            navigationController: nav,
            service: service,
            imageLoader: imageLoader
        )
        self.coordinator = appCoordinator

        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window

        Task { @MainActor in
            appCoordinator.start()
        }
    }
}
