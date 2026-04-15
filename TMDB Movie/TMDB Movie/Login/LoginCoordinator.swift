//
//  LoginCoordinator.swift
//  TMDB Movie
//
//  Created by ihan carlos on 09/01/26.
//

import UIKit

final class LoginCoordinator: Coordinator {

    let navigationController: UINavigationController
    var onFinish: (() -> Void)?

    private let service: TMDBServiceProtocol
    private let imageLoader: ImageLoaderProtocol

    init(
        navigationController: UINavigationController,
        service: TMDBServiceProtocol,
        imageLoader: ImageLoaderProtocol
    ) {
        self.navigationController = navigationController
        self.service = service
        self.imageLoader = imageLoader
    }

    @MainActor
    func start() {
        let loginVM = LoginViewModel(service: service)
        let vc = LoginViewController(viewModel: loginVM, imageLoader: imageLoader)

        vc.onLoginSuccess = { [weak self] in
            self?.onFinish?()
        }

        navigationController.setViewControllers([vc], animated: false)
    }
}
