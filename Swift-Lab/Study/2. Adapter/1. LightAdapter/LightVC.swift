//
//  LightVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/28/26.
//

/*
import UIKit

final class LightVC: UIViewController {
    private let items: [AnyComponent] = [
        AnyComponent(ProfileComponent(viewModel: "Kim Donghyeon")),
        AnyComponent(ProfileComponent(viewModel: "Adapter pattern with UIView content")),
        AnyComponent(ProfileComponent(viewModel: "One reuse cell, many renderable components"))
    ]

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 14
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 32, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var adapter = LightCollectionViewAdapter(items: items)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Light Adapter"
        view.backgroundColor = .systemGray6

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        adapter.attach(to: collectionView)
    }
}

#Preview {
    LightVC()
}
*/
