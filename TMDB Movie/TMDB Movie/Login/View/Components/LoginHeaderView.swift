//
//  LoginHeaderView.swift
//  TMDB Movie
//
//  Created by ihan carlos on 15/04/26.
//

import UIKit

protocol LoginHeaderViewProtocol: AnyObject {
    func accessButtonTapped()
}

final class LoginHeaderView: UIView {
    
    weak var delegate: LoginHeaderViewProtocol?
    public let slideshowView = RemoteImageSlideshowView()
    
    private lazy var gradientView: DSGradientView = {
        let view = DSGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .heroPoster
        return view
    }()

    private lazy var titleImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "TitleImage")
        return image
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tudo sobre filmes, séries, animes e muito mais."
        label.font = .dsFonts(.poppinsBold30)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fique por dentro das informações de filmes, séries, animes e muito mais."
        label.font = .dsFonts(.poppinsRegular15)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private lazy var acessButton: CustomButton = {
        let button = CustomButton(style: .containedQuadPurple)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Acessar", for: .normal)
        button.titleLabel?.font = .dsFonts(.poppinsBold12)
        button.addTarget(self, action: #selector(tappedAccessButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func tappedAccessButton() {
        delegate?.accessButtonTapped()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginHeaderView: ViewCodeType {
    func buildViewHierarchy() {
        addSubview(slideshowView)
        addSubview(gradientView)
        addSubview(titleImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(acessButton)
    }
    
    func setupConstraints() {
        slideshowView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )

        gradientView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )

        titleImageView.anchor(
            left: leftAnchor,
            bottom: titleLabel.topAnchor,
            leftConstant: 20,
            bottomConstant: 10,
            heightConstant: 15
        )

        titleLabel.anchor(
            left: titleImageView.leftAnchor,
            bottom: descriptionLabel.topAnchor,
            right: rightAnchor,
            bottomConstant: 20,
            rightConstant: 40
        )

        descriptionLabel.anchor(
            left: titleLabel.leftAnchor,
            bottom: acessButton.topAnchor,
            right: rightAnchor,
            bottomConstant: 15,
            rightConstant: 20
        )

        acessButton.anchor(
            left: descriptionLabel.leftAnchor,
            bottom: safeAreaLayoutGuide.bottomAnchor,
            right: descriptionLabel.rightAnchor,
            bottomConstant: 40,
            heightConstant: 43
        )
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .black
    }
}
