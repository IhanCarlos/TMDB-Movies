//
//  ChipsBarView.swift
//  TMDB Movie
//
//  Created by Arthur Ferreira on 08/01/26.
//

import UIKit

protocol ChipsBarViewDelegate: AnyObject {
    func chipsBarView(_ view: ChipsBarView, didSelect index: Int)
}

final class ChipsBarView: UIView {

    weak var delegate: ChipsBarViewDelegate?

    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.showsHorizontalScrollIndicator = false
        v.alwaysBounceHorizontal = true
        return v
    }()

    private let stackView: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.spacing = 12
        v.alignment = .fill
        v.distribution = .fill
        return v
    }()

    private var buttons: [ChipButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),

            stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) { nil }

    func configure(titles: [String], selectedIndex: Int = 0) {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for (idx, title) in titles.enumerated() {
            let button = ChipButton(title: title)
            button.tag = idx
            button.addTarget(self, action: #selector(didTapChip(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }

        select(index: selectedIndex, animated: false)
    }

    func select(index: Int, animated: Bool) {
        guard buttons.indices.contains(index) else { return }

        for (i, b) in buttons.enumerated() {
            b.isSelected = (i == index)
        }

        let button = buttons[index]
        let rect = button.convert(button.bounds, to: scrollView)
        scrollView.scrollRectToVisible(rect.insetBy(dx: -16, dy: 0), animated: animated)
    }

    @objc private func didTapChip(_ sender: UIButton) {
        let index = sender.tag
        select(index: index, animated: true)
        delegate?.chipsBarView(self, didSelect: index)
    }
}
