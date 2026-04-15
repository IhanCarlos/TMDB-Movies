//
//  HomeViewController.swift
//  TMDB Movie
//
//  Created by ihan carlos on 30/12/25.
//
import UIKit

final class HomeViewController: UIViewController {

    var onSelectPoster: ((PosterItem) -> Void)?

    private let viewModel: HomeViewModel
    private let imageLoader: ImageLoaderProtocol

    private let backgroundView = GradientBackgroundView(style: .purpleToDarkPurpleToBlack)
    private let headerView = HomeHeaderView()

    private var sections: [HomeSection] = []
    private var debounceWorkItem: DispatchWorkItem?
    private var isLoading: Bool = false

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.dataSource = self
        tv.delegate = self
        tv.register(HomeCarouselTableCell.self, forCellReuseIdentifier: HomeCarouselTableCell.reuseIdentifier)
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        return tv
    }()

    init(viewModel: HomeViewModel, imageLoader: ImageLoaderProtocol) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
        bind()
        bindHeader()
        viewModel.loadInitial()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debounceWorkItem?.cancel()
        Task { @MainActor in viewModel.cancel() }
    }

    deinit {
        debounceWorkItem?.cancel()
    }

    private func bind() {
        viewModel.onGenresChange = { [weak self] genres in
            self?.headerView.configureGenres(genres)
        }

        viewModel.onSectionsChange = { [weak self] sections in
            guard let self else { return }
            self.sections = sections
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
        }

        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            self.isLoading = (state == .loading)
            switch state {
            case .loading:
                self.tableView.alpha = 0.95
            default:
                self.tableView.alpha = 1.0
            }
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
        }
    }

    private func bindHeader() {
        headerView.onTextChange = { [weak self] text in
            guard let self else { return }
            self.debounceWorkItem?.cancel()

            let work = DispatchWorkItem { [weak self] in
                guard let self else { return }
                Task { @MainActor in self.viewModel.search(query: text) }
            }

            self.debounceWorkItem = work
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: work)
        }

        headerView.onSearch = { [weak self] text in
            guard let self else { return }
            self.debounceWorkItem?.cancel()
            Task { @MainActor in self.viewModel.search(query: text) }
            self.view.endEditing(true)
        }

        headerView.onSelectGenreIndex = { [weak self] idx in
            guard let self else { return }
            self.debounceWorkItem?.cancel()
            self.headerView.setSearchText("")
            self.view.endEditing(true)
            Task { @MainActor in self.viewModel.selectGenre(index: idx) }
        }
    }
}

extension HomeViewController: ViewCodeType {

    func buildViewHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(tableView)
    }

    func setupConstraints() {
        backgroundView.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )

        tableView.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
    }

    func setupAdditionalConfiguration() {
        navigationController?.setNavigationBarHidden(true, animated: false)

        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 220)
        tableView.tableHeaderView = headerView
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeCarouselTableCell.reuseIdentifier,
            for: indexPath
        ) as! HomeCarouselTableCell

        let section = sections[indexPath.row]
        cell.configure(section: section, imageLoader: imageLoader, isLoading: isLoading)

        cell.onSelect = { [weak self] item in
            self?.onSelectPoster?(item)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // header (10) + title(24) + subtitle(15) + spacing(12) + carousel(180) + bottom(8)
        return 10 + 24 + 15 + 12 + 180 + 8
    }
}
