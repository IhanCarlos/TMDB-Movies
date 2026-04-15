//
//  CastItemCell.swift
//  TMDB Movie
//
//  Created by ihan carlos on 09/01/26.
//

import UIKit

final class CastItemCell: UICollectionViewCell {

    static let reuseIdentifier = "CastItemCell"

    private var task: Task<Void, Never>?

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .darkGray
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.font = .dsFonts(.poppinsBold12)
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        task = nil
        imageView.image = nil
        imageView.backgroundColor = .darkGray
        nameLabel.text = nil
    }

    func configure(item: CastItem, imageLoader: ImageLoaderProtocol) {
        nameLabel.text = item.name
        imageView.image = nil
        imageView.backgroundColor = .darkGray

        guard let url = item.profileURL else { return }

        task = Task { [weak self] in
            guard let self else { return }
            if let image = try? await imageLoader.load(url) {
                await MainActor.run {
                    self.imageView.image = image
                    self.imageView.backgroundColor = .clear
                }
            }
        }
    }

    private func build() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 72),
            imageView.heightAnchor.constraint(equalToConstant: 72),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
}
