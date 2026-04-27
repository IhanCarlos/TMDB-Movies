//
//  HomeHeaderView.swift
//  TMDB Movie
//
//  Created by ihan carlos on 13/01/26.
//

import UIKit

final class HomeHeaderView: UIView {

    var onTextChange: ((String) -> Void)?
    var onSearch: ((String) -> Void)?
    var onSelectGenreIndex: ((Int) -> Void)?

    private var genres: [TMDBGenre] = []

    private var genreTitles: [String] {
        ["Todos"] + genres.map { $0.name }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "O que você quer assistir hoje?"
        label.font = .dsFonts(.poppinsBold24)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        iv.layer.cornerRadius = 20
        iv.contentMode = .scaleAspectFill
        iv.isAccessibilityElement = true
        iv.accessibilityLabel = "Perfil"
        return iv
    }()

    private let searchBarView = DSSearchBar()

    private func makeGenreLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }

    private lazy var genreCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: makeGenreLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceHorizontal = true
        cv.allowsMultipleSelection = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(CategoryTabCell.self, forCellWithReuseIdentifier: CategoryTabCell.reuseIdentifier)
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { nil }

    func configureGenres(_ genres: [TMDBGenre]) {
        self.genres = genres
        genreCollectionView.reloadData()

        genreCollectionView.selectItem(
            at: IndexPath(item: 0, section: 0),
            animated: false,
            scrollPosition: []
        )
    }

    func setSearchText(_ text: String) {
        searchBarView.setText(text)
    }

    private func bindSearch() {
        searchBarView.onTextChange = { [weak self] text in
            self?.onTextChange?(text)
        }
        searchBarView.onSearch = { [weak self] text in
            self?.onSearch?(text)
        }
    }
}

extension HomeHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genreTitles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryTabCell.reuseIdentifier,
            for: indexPath
        ) as! CategoryTabCell

        let title = genreTitles.indices.contains(indexPath.item) ? genreTitles[indexPath.item] : ""
        cell.configure(title: title)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectGenreIndex?(indexPath.item)
    }
}

extension HomeHeaderView: ViewCodeType {
    func buildViewHierarchy() {
        addSubview(profileImageView)
        addSubview(titleLabel)
        addSubview(searchBarView)
        addSubview(genreCollectionView)
    }
    
    func setupConstraints() {
        profileImageView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            right: rightAnchor,
            topConstant: 18,
            rightConstant: 20,
            widthConstant: 40,
            heightConstant: 40
        )
        
        titleLabel.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            left: leftAnchor,
            right: profileImageView.leftAnchor,
            topConstant: 14,
            leftConstant: 20,
            rightConstant: 20
        )
        
        searchBarView.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 10,
            leftConstant: 20,
            rightConstant: 20,
            heightConstant: 48
        )
        
        genreCollectionView.anchor(
            top: searchBarView.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            topConstant: 16,
            leftConstant: 20
        )
    }
    
    func setupAdditionalConfiguration() {
        bindSearch()
        searchBarView.configure(
            DSSearchBarViewData(
                placeholder: "Buscar",
                text: nil,
                isEnabled: true
            )
        )

        searchBarView.onSearch = { query in
            print("Buscar:", query)
        }
    }
}
