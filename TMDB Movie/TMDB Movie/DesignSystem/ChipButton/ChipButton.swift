//
//  ChipButton.swift
//  TMDB Movie
//
//  Created by Arthur Ferreira on 08/01/26.
//

import UIKit

final class ChipButton: UIButton {

    override var isSelected: Bool {
        didSet { updateStyle() }
    }

    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = .dsFonts(.poppinsBold14)
        layer.cornerRadius = 18
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        updateStyle()
    }

    required init?(coder: NSCoder) { nil }

    private func updateStyle() {
        if isSelected {
            backgroundColor = .ds(.pink)
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = .clear
            setTitleColor(UIColor.ds(.grayligth).withAlphaComponent(0.7), for: .normal)
        }
    }
}
