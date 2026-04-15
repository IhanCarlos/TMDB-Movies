//
//  SearchBarView.swift
//  TMDB Movie
//
//  Created by ihan carlos on 07/01/26.
//

import UIKit

final class SearchBarView: UIView, UITextFieldDelegate {

    struct ViewModel {
        let placeholder: String
        let text: String?
        let isSearchEnabled: Bool

        init(
            placeholder: String,
            text: String? = nil,
            isSearchEnabled: Bool = true
        ) {
            self.placeholder = placeholder
            self.text = text
            self.isSearchEnabled = isSearchEnabled
        }
    }

    var onSearch: ((String) -> Void)?
    var onTextChange: ((String) -> Void)?

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        return view
    }()

    private let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        tf.textColor = .white
        tf.font = .systemFont(ofSize: 16, weight: .regular)
        tf.returnKeyType = .search
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.clearButtonMode = .whileEditing
        tf.accessibilityLabel = "Buscar"
        return tf
    }()

    private let searchButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white.withAlphaComponent(0.7)
        button.accessibilityLabel = "Pesquisar"
        return button
    }()

    private let leftPaddingView: UIView = {
        UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }

    required init?(coder: NSCoder) { nil }

    func configure(_ viewModel: ViewModel) {
        textField.placeholder = viewModel.placeholder
        textField.text = viewModel.text
        setSearchEnabled(viewModel.isSearchEnabled)
        updatePlaceholderStyle()
        updateSearchButtonAppearance()
    }

    func setText(_ text: String) {
        textField.text = text
        updateSearchButtonAppearance()
    }

    func setSearchEnabled(_ enabled: Bool) {
        textField.isEnabled = enabled
        searchButton.isEnabled = enabled
        containerView.alpha = enabled ? 1.0 : 0.65
        updateSearchButtonAppearance()
    }

    private func build() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(containerView)
        containerView.addSubview(textField)
        containerView.addSubview(searchButton)

        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.25)

        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)

        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.delegate = self
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)

        searchButton.setContentHuggingPriority(.required, for: .horizontal)
        searchButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            searchButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            searchButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 44),
            searchButton.heightAnchor.constraint(equalToConstant: 44),

            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: containerView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])

        isAccessibilityElement = false
        accessibilityElements = [textField, searchButton]

        updatePlaceholderStyle()
        updateSearchButtonAppearance()
    }

    private func updatePlaceholderStyle() {
        guard let placeholder = textField.placeholder else { return }
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.35),
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attrs)
    }

    private func currentQuery() -> String {
        (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func updateSearchButtonAppearance() {
        let hasText = !currentQuery().isEmpty
        let enabled = textField.isEnabled && searchButton.isEnabled
        searchButton.tintColor = UIColor.white.withAlphaComponent((enabled && hasText) ? 1.0 : 0.6)
    }

    @objc private func didTapSearch() {
        onSearch?(currentQuery())
    }

    @objc private func textDidChange() {
        onTextChange?(textField.text ?? "")
        updateSearchButtonAppearance()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapSearch()
        textField.resignFirstResponder()
        return true
    }
}

