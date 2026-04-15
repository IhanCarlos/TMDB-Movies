//
//  GradientBackgroundView.swift
//  TMDB Movie
//
//  Created by ihan carlos on 09/01/26.
//

import UIKit

final class GradientBackgroundView: UIView {

    enum Style {
        case purpleToBlack
        case purpleToDarkPurpleToBlack
    }

    private let gradientLayer = CAGradientLayer()
    private let style: Style

    init(style: Style = .purpleToDarkPurpleToBlack) {
        self.style = style
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        layer.insertSublayer(gradientLayer, at: 0)
        applyStyle()
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func applyStyle() {
        switch style {
        case .purpleToBlack:
            gradientLayer.colors = [
                UIColor.ds(.purple).cgColor,
                UIColor.black.cgColor
            ]
            gradientLayer.locations = [0.0, 1.0]

        case .purpleToDarkPurpleToBlack:
            gradientLayer.colors = [
                UIColor.ds(.purple).cgColor,
                UIColor(red: 18/255, green: 10/255, blue: 35/255, alpha: 1).cgColor,
                UIColor.black.cgColor
            ]
            gradientLayer.locations = [0.0, 0.55, 1.0]
        }

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
}
