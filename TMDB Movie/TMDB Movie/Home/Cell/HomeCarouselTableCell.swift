//
//  HomeCarouselTableCell.swift
//  TMDB Movie
//
//  Created by ihan carlos on 13/01/26.
//

import UIKit

final class HomeCarouselTableCell: UITableViewCell {

    static let reuseIdentifier = "HomeCarouselTableCell"

    var onSelect: ((PosterItem) -> Void)?

    private var items: [PosterItem] = []
    private var imageLoader: ImageLoaderProtocol?
    private var isLoading: Bool = false

    private let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.font = .dsFonts(.poppinsBold24)
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.white.withAlphaComponent(0.6)
        l.font = .dsFonts(.poppinsRegular15)
        return l
    }()

    private let headerStack: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.spacing = 4
        return s
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 14

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.decelerationRate = .fast
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // ✅ padding Netflix
        cv.register(PosterItemCell.self, forCellWithReuseIdentifier: PosterItemCell.reuseIdentifier)
        return cv
    }()

    private var heightConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        build()
    }

    required init?(coder: NSCoder) { nil }

    override func prepareForReuse() {
        super.prepareForReuse()
        onSelect = nil
        imageLoader = nil
        items = []
        isLoading = false
        collectionView.setContentOffset(.zero, animated: false)
    }

    func configure(section: HomeSection, imageLoader: ImageLoaderProtocol, isLoading: Bool) {
        self.isLoading = isLoading
        self.imageLoader = imageLoader

        titleLabel.text = section.type.title
        subtitleLabel.text = section.type.subtitle
        subtitleLabel.isHidden = (section.type.subtitle == nil)

        self.items = section.items

        UIView.performWithoutAnimation {
            collectionView.reloadData()
        }
    }

    private func build() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(container)

        container.addSubview(headerStack)
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(subtitleLabel)

        container.addSubview(collectionView)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            headerStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            headerStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),   // ✅ padding
            headerStack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -20),

            collectionView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])

        heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 180)
        heightConstraint?.isActive = true
    }
}

extension HomeCarouselTableCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // ✅ skeleton: mostra 10 placeholders quando está carregando
        return isLoading ? 10 : items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PosterItemCell.reuseIdentifier,
            for: indexPath
        ) as! PosterItemCell

        if isLoading {
            cell.configureSkeleton()
            return cell
        }

        if let loader = imageLoader, items.indices.contains(indexPath.item) {
            cell.configure(item: items[indexPath.item], imageLoader: loader)
        } else {
            cell.configureSkeleton()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isLoading, items.indices.contains(indexPath.item) else { return }
        onSelect?(items[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
}
