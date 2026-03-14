//
//  ProductCollectionViewAdapter.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/5/26.
//

import UIKit

protocol ProductListDataSource: AnyObject {
    var products: [String] { get }
}

protocol ProductListAdapterDelegate: AnyObject {
    func productListAdapter(
        _ adapter: ProductListCollectionAdapter,
        didSelect product: String
    )
}

final class ProductListCollectionAdapter: NSObject {

    private weak var dataSource: ProductListDataSource?
    private weak var delegate: ProductListAdapterDelegate?

    init(
        dataSource: ProductListDataSource,
        delegate: ProductListAdapterDelegate
    ) {
        self.dataSource = dataSource
        self.delegate = delegate
    }

    func configure(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            ProductListCell.self,
            forCellWithReuseIdentifier: ProductListCell.reuseIdentifier
        )
    }
}

extension ProductListCollectionAdapter: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        dataSource?.products.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductListCell.reuseIdentifier,
                for: indexPath
            ) as? ProductListCell,
            let product = dataSource?.products[indexPath.item]
        else { return UICollectionViewCell() }

        cell.configure(product)

        return cell
    }
}

extension ProductListCollectionAdapter: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {

        guard let product = dataSource?.products[indexPath.item] else { return }

        delegate?.productListAdapter(
            self,
            didSelect: product
        )
    }
}

extension ProductListCollectionAdapter: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let width = (collectionView.bounds.width - 24) / 2
        return CGSize(width: width, height: 220)
    }
}


import UIKit

final class ProductListCell: UICollectionViewCell {

    static let reuseIdentifier = "ProductListCell"

    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension ProductListCell {

    func setupViews() {

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.numberOfLines = 2

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }

    func setupLayout() {

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
}

extension ProductListCell {

    func configure(_ title: String) {

        titleLabel.text = title
        imageView.image = UIImage(systemName: "photo")
    }
}

final class ProductListViewModel: ProductListDataSource {

    var products: [String] = [
        "iPhone",
        "MacBook",
        "AirPods",
        "Apple Watch",
        "iPad",
        "Vision Pro",
        "iPhone",
        "MacBook",
        "AirPods",
        "Apple Watch",
        "iPad",
        "Vision Pro"
    ]
}

import UIKit

final class ProductListViewController: UIViewController {

    private let viewModel = ProductListViewModel ()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private lazy var adapter = ProductListCollectionAdapter(
        dataSource: viewModel,
        delegate: self
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        adapter.configure(collectionView)
    }
}

private extension ProductListViewController {

    func setupUI() {

        view.backgroundColor = .white

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ProductListViewController: ProductListAdapterDelegate {

    func productListAdapter(
        _ adapter: ProductListCollectionAdapter,
        didSelect product: String
    ) {
        print("선택된 상품:", product)
    }
}
