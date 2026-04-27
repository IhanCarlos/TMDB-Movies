//
//  SearchBarView.swift
//  TMDB Movie
//
//  Created by ihan carlos on 07/01/26.
//

import UIKit

struct DSSearchBarViewData {
    let placeholder: String
    let text: String?
    let isEnabled: Bool
}

struct DSSearchBarStyle {
    let backgroundColor: UIColor
    let textColor: UIColor
    let placeholderColor: UIColor
    let tintColor: UIColor
    let disabledAlpha: CGFloat

    static let dark = DSSearchBarStyle(
        backgroundColor: UIColor.black.withAlphaComponent(0.25),
        textColor: .white,
        placeholderColor: UIColor.white.withAlphaComponent(0.35),
        tintColor: .white,
        disabledAlpha: 0.6
    )
}

final class DSSearchBar: UIView {

    var onSearch: ((String) -> Void)?
    var onTextChange: ((String) -> Void)?

    private let style: DSSearchBarStyle

    private let containerView = UIView()
    private let textField = UITextField()
    private let searchButton = UIButton()
    private let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))

    init(style: DSSearchBarStyle = .dark) {
        self.style = style
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewData: DSSearchBarViewData) {
        textField.text = viewData.text
        textField.placeholder = viewData.placeholder
        setEnabled(viewData.isEnabled)
        updatePlaceholder()
        updateButton()
    }
    
    func setText(_ text: String) {
           textField.text = text
           updateButton()
       }

    func setEnabled(_ enabled: Bool) {
        textField.isEnabled = enabled
        searchButton.isEnabled = enabled
        containerView.alpha = enabled ? 1.0 : style.disabledAlpha
    }
}

extension DSSearchBar: ViewCodeType {

    func buildViewHierarchy() {
        addSubview(containerView)
        containerView.addSubview(textField)
        containerView.addSubview(searchButton)
    }

    func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        
        searchButton.anchor(
            right: containerView.rightAnchor,
            centerY: containerView.centerYAnchor,
            rightConstant: 12,
            widthConstant: 44,
            heightConstant: 44
        )
        
        textField.anchor(
            top: containerView.topAnchor,
            left: containerView.leftAnchor,
            bottom: containerView.bottomAnchor,
            right: containerView.rightAnchor,
            heightConstant: 48
        )
    }

    func setupAdditionalConfiguration() {
        translatesAutoresizingMaskIntoConstraints = false

        containerView.layer.cornerRadius = 24
        containerView.backgroundColor = style.backgroundColor

        textField.textColor = style.textColor
        textField.font = .systemFont(ofSize: 16)
        textField.returnKeyType = .search
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)

        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = style.tintColor
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)

        isAccessibilityElement = false
        accessibilityElements = [textField, searchButton]
    }
}

private extension DSSearchBar {

    func updatePlaceholder() {
        guard let placeholder = textField.placeholder else { return }

        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: style.placeholderColor,
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )
    }

    func currentQuery() -> String {
        (textField.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func updateButton() {
        let hasText = !currentQuery().isEmpty
        searchButton.alpha = hasText ? 1.0 : 0.6
    }

    @objc func searchTapped() {
        onSearch?(currentQuery())
    }

    @objc func textChanged() {
        onTextChange?(textField.text ?? "")
        updateButton()
    }
}

extension DSSearchBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTapped()
        textField.resignFirstResponder()
        return true
    }
}
