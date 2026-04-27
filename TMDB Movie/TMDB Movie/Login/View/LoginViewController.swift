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
    private let scenneView = LoginHeaderView()

    init(viewModel: LoginViewModel, imageLoader: ImageLoaderProtocol) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.load()
        
        view.addSubview(scenneView)
        scenneView.frame = view.bounds
        scenneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scenneView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            scenneView.slideshowView.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scenneView.slideshowView.stop()
        viewModel.cancel()
    }

    private func bind() {
        viewModel.onBackgroundURLsChange = { [weak self] urls in
            guard let self else { return }
            scenneView.slideshowView.configure(urls: urls, imageLoader: self.imageLoader, interval: 4.0)
            scenneView.slideshowView.start()
        }
    }
}

extension LoginViewController: LoginHeaderViewProtocol {
    func accessButtonTapped() {
        onLoginSuccess?()
    }
}

