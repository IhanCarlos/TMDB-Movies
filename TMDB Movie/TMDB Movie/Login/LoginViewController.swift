//
//  LoginViewController.swift
//  TMDB Movie
//
//  Created by ihan carlos on 30/12/25.
//

import UIKit

final class LoginViewController: UIViewController {

    var onLoginSuccess: (() -> Void)?

    private let viewModel: LoginViewModel
    private let imageLoader: ImageLoaderProtocol

    private let slideshowView = RemoteImageSlideshowView()

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

    init(viewModel: LoginViewModel, imageLoader: ImageLoaderProtocol) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        viewModel.load()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slideshowView.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        slideshowView.stop()
        viewModel.cancel()
    }

    @objc private func tappedAccessButton() {
        onLoginSuccess?()
    }

    private func bind() {
        viewModel.onBackgroundURLsChange = { [weak self] urls in
            guard let self else { return }
            self.slideshowView.configure(urls: urls, imageLoader: self.imageLoader, interval: 4.0)
            self.slideshowView.start()
        }
    }
}

extension LoginViewController: ViewCodeType {

    func buildViewHierarchy() {
        view.addSubview(slideshowView)
        view.addSubview(gradientView)
        view.addSubview(titleImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(acessButton)
    }

    func setupConstraints() {
        slideshowView.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )

        gradientView.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )

        titleImageView.anchor(
            left: view.leftAnchor,
            bottom: titleLabel.topAnchor,
            leftConstant: 20,
            bottomConstant: 10,
            heightConstant: 15
        )

        titleLabel.anchor(
            left: titleImageView.leftAnchor,
            bottom: descriptionLabel.topAnchor,
            right: view.rightAnchor,
            bottomConstant: 20,
            rightConstant: 40
        )

        descriptionLabel.anchor(
            left: titleLabel.leftAnchor,
            bottom: acessButton.topAnchor,
            right: view.rightAnchor,
            bottomConstant: 15,
            rightConstant: 20
        )

        acessButton.anchor(
            left: descriptionLabel.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: descriptionLabel.rightAnchor,
            bottomConstant: 40,
            heightConstant: 43
        )
    }

    func setupAdditionalConfiguration() {
        view.backgroundColor = .black
    }
}
