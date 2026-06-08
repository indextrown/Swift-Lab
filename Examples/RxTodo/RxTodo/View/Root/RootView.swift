//  RootView.swift
//  RxTodo
//
//  Created by 김동현 on 5/4/26.
//

import UIKit

final class RootView: UIView {

    // MARK: - UI Component
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .label
        label.text = "Loading todos..."
        return label
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(messageLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            trailingAnchor.constraint(greaterThanOrEqualTo: messageLabel.trailingAnchor, constant: 24),
        ])
    }

    func updateMessage(_ message: String) {
        messageLabel.text = message
    }
}

#Preview {
    RootView()
}
