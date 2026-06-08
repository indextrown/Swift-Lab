////
////  Component.swift
////  Swift-Lab
////
////  Created by 김동현 on 4/28/26.
////
//
//import UIKit
//
//protocol Component {
//    associatedtype Cell: UICollectionViewCell
//    var reuseIdentifier: String { get }
//
//    func register(on collectionView: UICollectionView)
//    func configure(_ cell: Cell)
//}
//
//final class NumberCell: UICollectionViewCell {
//    private let valueLabel = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func apply(_ value: Int) {
//        valueLabel.text = "\(value)"
//    }
//}
//
//final class MessageCell: UICollectionViewCell {
//    private let iconView = UIImageView()
//    private let messageLabel = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func apply(_ value: String) {
//        messageLabel.text = value
//    }
//}
//
//private extension NumberCell {
//    func setupUI() {
//        contentView.backgroundColor = .systemBlue
//        contentView.layer.cornerRadius = 18
//
//        valueLabel.font = .systemFont(ofSize: 28, weight: .bold)
//        valueLabel.textColor = .white
//        valueLabel.textAlignment = .center
//
//        contentView.addSubview(valueLabel)
//        valueLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
//            valueLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 64),
//            valueLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
//        ])
//    }
//}
//
//private extension MessageCell {
//    func setupUI() {
//        contentView.backgroundColor = .white
//        contentView.layer.cornerRadius = 18
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.systemGray4.cgColor
//
//        iconView.image = UIImage(systemName: "text.bubble.fill")
//        iconView.tintColor = .systemGreen
//        iconView.contentMode = .scaleAspectFit
//
//        messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
//        messageLabel.textColor = .label
//        messageLabel.numberOfLines = 0
//
//        contentView.addSubview(iconView)
//        contentView.addSubview(messageLabel)
//
//        iconView.translatesAutoresizingMaskIntoConstraints = false
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
//            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            iconView.widthAnchor.constraint(equalToConstant: 24),
//            iconView.heightAnchor.constraint(equalToConstant: 24),
//
//            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
//            messageLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
//            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
//            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 220)
//        ])
//    }
//}
//
//struct NumberComponent: Component {
//    let value: Int
//    var reuseIdentifier: String { "NumberCell" }
//
//    func register(on collectionView: UICollectionView) {
//        collectionView.register(NumberCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//    }
//
//    func configure(_ cell: NumberCell) {
//        cell.apply(value)
//    }
//}
//
//struct MessageComponent: Component {
//    let value: String
//    var reuseIdentifier: String { "MessageCell" }
//
//    func register(on collectionView: UICollectionView) {
//        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//    }
//
//    func configure(_ cell: MessageCell) {
//        cell.apply(value)
//    }
//}
//
//private protocol ComponentBox {
//    var reuseIdentifier: String { get }
//    func register(on collectionView: UICollectionView)
//    func configure(cell: UICollectionViewCell)
//}
//
//private struct AnyComponentBox<Base: Component>: ComponentBox {
//    let base: Base
//
//    var reuseIdentifier: String { base.reuseIdentifier }
//
//    func register(on collectionView: UICollectionView) {
//        base.register(on: collectionView)
//    }
//
//    func configure(cell: UICollectionViewCell) {
//        guard let cell = cell as? Base.Cell else { return }
//        base.configure(cell)
//    }
//}
//
//struct AnyComponent {
//    private let box: any ComponentBox
//
//    init(_ base: some Component) {
//        self.box = AnyComponentBox(base: base)
//    }
//
//    var reuseIdentifier: String { box.reuseIdentifier }
//
//    func register(on collectionView: UICollectionView) {
//        box.register(on: collectionView)
//    }
//
//    func configure(cell: UICollectionViewCell) {
//        box.configure(cell: cell)
//    }
//}
//
//final class BasicCollectionViewAdapter: NSObject {
//    private let items: [AnyComponent]
//
//    init(items: [AnyComponent]) {
//        self.items = items
//    }
//
//    func attach(to collectionView: UICollectionView) {
//        registerAll(on: collectionView)
//        collectionView.dataSource = self
//    }
//}
//
//extension BasicCollectionViewAdapter: UICollectionViewDataSource {
//    func registerAll(on collectionView: UICollectionView) {
//        items.forEach { $0.register(on: collectionView) }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        items.count
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath
//    ) -> UICollectionViewCell {
//        let item = items[indexPath.item]
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: item.reuseIdentifier,
//            for: indexPath
//        )
//
//        item.configure(cell: cell)
//        return cell
//    }
//}
