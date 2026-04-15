//
//  DescriptionViewController.swift
//  TMDB Movie
//
//  Created by ihan carlos on 08/01/26.
//
import UIKit

final class DescriptionViewController: UIViewController {

    var onBack: (() -> Void)?
    var onTapTrailer: ((String) -> Void)?
    var onSelectRecommendation: ((PosterItem) -> Void)?

    private let contentView = DescriptionView()
    private let viewModel: DescriptionViewModel
    private let imageLoader: ImageLoaderProtocol

    private var headerTask: Task<Void, Never>?
    private var trailerKey: String?
    private var latestViewModel: DescriptionView.ViewModel?

    init(viewModel: DescriptionViewModel, imageLoader: ImageLoaderProtocol) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.load()
    }

    deinit {
        headerTask?.cancel()
        Task { @MainActor [viewModel] in
            viewModel.cancel()
        }
    }

    private func bind() {
        contentView.onTapBack = { [weak self] in
            self?.onBack?()
        }

        contentView.onTapTrailer = { [weak self] in
            guard let self, let key = self.trailerKey else { return }
            self.onTapTrailer?(key)
        }

        contentView.onSelectRecommendation = { [weak self] item in
            self?.onSelectRecommendation?(item)
        }

        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {
            case .idle:
                break

            case .loading:
                break

            case .error:
                break

            case .loaded(let output):
                self.trailerKey = output.trailerKey
                self.latestViewModel = output.viewModel
                self.contentView.configure(output.viewModel, imageLoader: self.imageLoader)
                self.loadBackdropIfNeeded(url: output.backdropURL)
            }
        }
    }

    private func loadBackdropIfNeeded(url: URL?) {
        headerTask?.cancel()
        guard let url, var current = latestViewModel else { return }

        headerTask = Task { [weak self] in
            guard let self else { return }
            guard let image = try? await self.imageLoader.load(url) else { return }

            current = DescriptionView.ViewModel(
                header: .init(image: image, isFavorite: current.header.isFavorite),
                summary: current.summary,
                overview: current.overview,
                ctaTitle: current.ctaTitle,
                cast: current.cast,
                categories: current.categories,
                recommendations: current.recommendations
            )

            self.latestViewModel = current
            self.contentView.configure(current, imageLoader: self.imageLoader)
        }
    }
}
