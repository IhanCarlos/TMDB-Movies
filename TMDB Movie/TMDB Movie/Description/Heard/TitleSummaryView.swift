//
//  TitleSummaryView.swift
//  TMDB Movie
//
//  Created by Arthur Ferreira on 09/01/26.
//

import UIKit

final class TitleSummaryView: UIView {

    struct ViewModel: Equatable {
        let ratingPercent: Int
        let title: String
        let meta: String
    }

    private let ringView = ProgressRingView()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.font = .systemFont(ofSize: 26, weight: .bold)
        l.numberOfLines = 2
        return l
    }()

    private let metaLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.white.withAlphaComponent(0.7)
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.numberOfLines = 1
        return l
    }()

    private let vStack: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.spacing = 6
        return s
    }()

    private let hStack: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        s.alignment = .center
        s.spacing = 14
        return s
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }

    required init?(coder: NSCoder) { nil }

    func configure(_ viewModel: ViewModel) {
        ringView.setProgress(Double(viewModel.ratingPercent) / 100.0, text: "\(viewModel.ratingPercent)%")
        titleLabel.text = viewModel.title
        metaLabel.text = viewModel.meta
    }

    private func build() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(hStack)
        hStack.addArrangedSubview(ringView)
        hStack.addArrangedSubview(vStack)

        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(metaLabel)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            ringView.widthAnchor.constraint(equalToConstant: 56),
            ringView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
