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
        setupView()
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

extension CategoryTabCell: ViewCodeType {
    func buildViewHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.anchor(
            top: contentView.topAnchor,
            left: contentView.leftAnchor,
            bottom: contentView.bottomAnchor,
            right: contentView.rightAnchor,
            topConstant: 8,
            leftConstant: 12,
            bottomConstant: 8,
            rightConstant: 12
        )
    }
    
    func setupAdditionalConfiguration() {
        contentView.layer.cornerRadius = 18
        contentView.clipsToBounds = true
        updateStyle()
    }
}
