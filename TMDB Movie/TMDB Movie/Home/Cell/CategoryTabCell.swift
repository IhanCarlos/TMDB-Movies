//
//  CategoryTabCell.swift
//  TMDB Movie
//
//  Created by ihan carlos on 08/01/26.
//

import UIKit

final class CategoryTabCell: UICollectionViewCell {

    static let reuseIdentifier = "CategoryTabCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .dsFonts(.poppinsBold14)
        label.textAlignment = .center
        return label
    }()

    override var isSelected: Bool {
        didSet { updateStyle() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { nil }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    func configure(title: String) {
        titleLabel.text = title
        updateStyle()
    }

    private func setup() {
        
        contentView.layer.cornerRadius = 18
        contentView.clipsToBounds = true

        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        updateStyle()
    }

    private func updateStyle() {
        if isSelected {
            contentView.backgroundColor = .ds(.pink)
            titleLabel.textColor = .white
        } else {
            contentView.backgroundColor = UIColor.white.withAlphaComponent(0.08)
            titleLabel.textColor = UIColor.ds(.grayligth).withAlphaComponent(0.8)
        }
    }
}
