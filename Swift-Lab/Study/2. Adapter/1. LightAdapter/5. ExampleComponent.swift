////
////  ExampleComponent.swift
////  Swift-Lab
////
////  Created by 김동현 on 4/28/26.
////
//
//import UIKit
//
//struct ProfileComponent: Component {
//    let layoutMode: ContentLayoutMode
//    
//    let viewModel: String
//
//    func renderContent(coordinator: Void) -> ProfileContentView {
//        ProfileContentView()
//    }
//
//    func render(in content: ProfileContentView, coordinator: Void) {
//        content.apply(title: viewModel)
//    }
//}
//
//final class ProfileContentView: UIView {
//    private let iconView = UIImageView()
//    private let titleLabel = UILabel()
//    private let subtitleLabel = UILabel()
//    private let badgeLabel = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        backgroundColor = .white
//        layer.cornerRadius = 20
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.systemGray4.cgColor
//
//        iconView.image = UIImage(systemName: "person.crop.circle.fill")
//        iconView.tintColor = .systemOrange
//        iconView.contentMode = .scaleAspectFit
//
//        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
//        titleLabel.textColor = .label
//
//        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
//        subtitleLabel.textColor = .secondaryLabel
//        subtitleLabel.text = "Light component rendered inside one container cell"
//        subtitleLabel.numberOfLines = 0
//
//        badgeLabel.font = .systemFont(ofSize: 12, weight: .bold)
//        badgeLabel.textColor = .systemOrange
//        badgeLabel.backgroundColor = .systemOrange.withAlphaComponent(0.14)
//        badgeLabel.layer.cornerRadius = 10
//        badgeLabel.clipsToBounds = true
//        badgeLabel.textAlignment = .center
//        badgeLabel.text = "PROFILE"
//
//        addSubview(iconView)
//        addSubview(titleLabel)
//        addSubview(subtitleLabel)
//        addSubview(badgeLabel)
//
//        iconView.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 18),
//            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
//            iconView.widthAnchor.constraint(equalToConstant: 40),
//            iconView.heightAnchor.constraint(equalToConstant: 40),
//
//            badgeLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
//            badgeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
//            badgeLabel.widthAnchor.constraint(equalToConstant: 78),
//            badgeLabel.heightAnchor.constraint(equalToConstant: 28),
//
//            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 14),
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
//
//            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
//            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
//            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func apply(title: String) {
//        titleLabel.text = title
//    }
//}
