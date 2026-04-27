//
//  HomeCoordinator.swift
//  TMDB Movie
//
//  Created by ihan carlos on 09/01/26.
//

import UIKit
import SafariServices

final class HomeCoordinator: Coordinator {

    let navigationController: UINavigationController

    private let service: TMDBServiceProtocol
    private let imageLoader: ImageLoaderProtocol

    init(navigationController: UINavigationController, service: TMDBServiceProtocol, imageLoader: ImageLoaderProtocol) {
        self.navigationController = navigationController
        self.service = service
        self.imageLoader = imageLoader
    }

    @MainActor
    func start() {
        let viewModel = HomeViewModel(service: service)
        let vc = HomeViewController(viewModel: viewModel, imageLoader: imageLoader)

        vc.onSelectPoster = { [weak self] item in
            guard let self else { return }
            Task { @MainActor in
                self.showDescription(item: item)
            }
        }

        navigationController.setViewControllers([vc], animated: false)
    }

    @MainActor
    private func showDescription(item: PosterItem) {
        let vm = DescriptionViewModel(service: service, movieId: item.id)
        let vc = DescriptionViewController(viewModel: vm, imageLoader: imageLoader)

        vc.onBack = { [weak self] in
            guard let self else { return }
            Task { @MainActor in
                self.navigationController.popViewController(animated: true)
            }
        }

        vc.onTapTrailer = { [weak self] key in
            guard let self else { return }
            Task { @MainActor in
                self.showTrailer(youtubeKey: key)
            }
        }

        vc.onSelectRecommendation = { [weak self] recItem in
            guard let self else { return }
            Task { @MainActor in
                self.showDescription(item: recItem)
            }
        }

        navigationController.pushViewController(vc, animated: true)
    }

    @MainActor
    private func showTrailer(youtubeKey: String) {
        guard let url = URL(string: "https://www.youtube.com/watch?v=\(youtubeKey)") else { return }
        let safari = SFSafariViewController(url: url)
        safari.modalPresentationStyle = .pageSheet
        navigationController.present(safari, animated: true)
    }
}
