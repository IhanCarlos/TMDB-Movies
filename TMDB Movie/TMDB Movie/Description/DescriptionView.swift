//
//  DescriptionView.swift
//  TMDB Movie
//
//  Created by ihan carlos on 09/01/26.
//

import UIKit

final class DescriptionView: UIView {

    struct ViewModel {
        let header: HeroHeaderView.ViewModel
        let summary: TitleSummaryView.ViewModel
        let overview: String
        let ctaTitle: String
        let cast: CastSectionView.ViewModel
        let categories: ChipsSectionView.ViewModel
        let recommendations: RecommendationsSectionView.ViewModel
    }

    var onTapBack: (() -> Void)?
    var onTapFavorite: (() -> Void)?
    var onTapTrailer: (() -> Void)?
    var onSelectCast: ((CastItem) -> Void)?
    var onSelectRecommendation: ((PosterItem) -> Void)?

    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.showsVerticalScrollIndicator = false
        s.contentInsetAdjustmentBehavior = .never
        return s
    }()

    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let headerView = HeroHeaderView()
    private let summaryView = TitleSummaryView()

    private let overviewLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.white.withAlphaComponent(0.75)
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.numberOfLines = 0
        return l
    }()

    private let trailerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.systemPurple.withAlphaComponent(0.85)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.title = "Assistir trailer"
        config.image = UIImage(systemName: "play.circle")
        config.imagePadding = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 18, bottom: 16, trailing: 18)

        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let castSectionView = CastSectionView()
    private let categoriesSectionView = ChipsSectionView()
    private let recommendationsSectionView = RecommendationsSectionView()

    private let contentStack: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.spacing = 16
        return s
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }

    required init?(coder: NSCoder) { nil }

    func configure(_ viewModel: ViewModel, imageLoader: ImageLoaderProtocol) {
        headerView.configure(viewModel.header)
        summaryView.configure(viewModel.summary)
        overviewLabel.text = viewModel.overview

        var config = trailerButton.configuration
        config?.title = viewModel.ctaTitle
        trailerButton.configuration = config

        castSectionView.configure(viewModel.cast, imageLoader: imageLoader)
        categoriesSectionView.configure(viewModel.categories)
        recommendationsSectionView.configure(viewModel.recommendations, imageLoader: imageLoader)
    }

    private func build() {
        backgroundColor = .black

        addSubview(scrollView)
        scrollView.addSubview(containerView)

        containerView.addSubview(headerView)
        containerView.addSubview(contentStack)

        contentStack.addArrangedSubview(summaryView)
        contentStack.addArrangedSubview(overviewLabel)
        contentStack.addArrangedSubview(trailerButton)
        contentStack.addArrangedSubview(castSectionView)
        contentStack.addArrangedSubview(categoriesSectionView)
        contentStack.addArrangedSubview(recommendationsSectionView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            containerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 420),

            contentStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -64),
            contentStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),

            trailerButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 56)
        ])

        headerView.onTapBack = { [weak self] in self?.onTapBack?() }
        headerView.onTapFavorite = { [weak self] in self?.onTapFavorite?() }

        trailerButton.addTarget(self, action: #selector(didTapTrailer), for: .touchUpInside)

        castSectionView.onSelect = { [weak self] item in
            self?.onSelectCast?(item)
        }

        recommendationsSectionView.onSelect = { [weak self] item in
            self?.onSelectRecommendation?(item)
        }
    }

    @objc private func didTapTrailer() {
        onTapTrailer?()
    }
}
