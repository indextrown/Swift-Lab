//
//  CollectionBasicVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/19/26.
//

import UIKit

final class CollectionBasicVC: UIViewController {
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.alwaysBounceVertical = true
        return view
    }()
    
    // MARK: - Data
    
    private let fruits: [Fruit] = [
        Fruit(name: "Apple", color: .systemRed),
        Fruit(name: "Banana", color: .systemYellow),
        Fruit(name: "Orange", color: .systemOrange),
        Fruit(name: "Grape", color: .systemPurple),
        Fruit(name: "Melon", color: .systemGreen),
        Fruit(name: "Blueberry", color: .systemBlue)
    ]
    
    private lazy var dataSource = FruitCollectionViewDataSource(items: fruits)
    private lazy var delegate = FruitCollectionViewDelegate(dataSource: dataSource)
    
    // MARK: - Lifecycle
    
    /// 뷰가 메모리에 로드된 직후 호출됩니다.
    /// 컬렉션 뷰 설정, delegate/dataSource 연결, 레이아웃 구성을 수행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupLayout()
        bind()
    }
    
    // MARK: - Setup
    
    /// 뷰 컨트롤러의 기본 UI를 설정합니다.
    private func setupUI() {
        title = "UICollectionView Basic"
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    /// 컬렉션 뷰의 셀 등록과 delegate/dataSource 연결을 수행합니다.
    private func setupCollectionView() {
        collectionView.register(
            FruitCell.self,
            forCellWithReuseIdentifier: String(describing: FruitCell.self)
        )
        
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
    }
    
    /// 컬렉션 뷰의 오토레이아웃 제약 조건을 설정합니다.
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// delegate 이벤트를 바인딩합니다.
    private func bind() {
        delegate.didSelectItem = { [weak self] fruit in
            let alert = UIAlertController(
                title: "선택됨",
                message: "\(fruit.name)을 선택했습니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
