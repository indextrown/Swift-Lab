//
//  CollectionViewAdapter.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/24/26.
//

import UIKit

// UICollectionView가 필요할 때 나중에 실행하려고 클로저를 저장하기 때문
// 클로저를 나중에 실행하려고 저장하기 때문에 escaping이 필요하다
// 함수 끝났는데도 계속 가지고 있음, 나중에 실행하려고 저장
/**
 let adapter = CollectionViewAdapter(
     numberOfItens: { _, _ in 10 },
     cellForItem: { collectionView, indexPath in
         return UICollectionViewCell()
     },
     didSelectItem: { _, _ in print("tap") }
 )
 init에서 저장되고 iinit이 끝나도 살아있음 = escaping
 
 collectionView(_:cellForItemAt:)
 나중에 이런 delegate에서 실행됨
 
 // w정리: 지금 실행 안 하고, 나중에 실행하려고 들고 있는 클로저 = escaping
 */
final class CollectionViewAdapter: NSObject {
    public typealias NumberOfItems = (_ collectionView: UICollectionView, _ section: Int) -> Int
    public typealias CellForItem = (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell
    public typealias DidSelectItem = (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void
    
    private let numberOfItems: NumberOfItems
    private let cellForItem: CellForItem
    private let didSelectItem: DidSelectItem?
    
    public init(
        numberOfItems: @escaping NumberOfItems,
        cellForItem: @escaping CellForItem,
        didSelectItem: DidSelectItem? = nil
    ) {
        self.numberOfItems = numberOfItems
        self.cellForItem = cellForItem
        self.didSelectItem = didSelectItem
    }
    
    public func attach(to collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension CollectionViewAdapter: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        numberOfItems(collectionView, section)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        cellForItem(collectionView, indexPath)
    }
}

extension CollectionViewAdapter: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        didSelectItem?(collectionView, indexPath)
    }
}


final class AdapterSampleVC: UIViewController {
    
    private let items = ["A", "B", "C", "A", "B", "C", "A", "B", "C", "A", "B", "C"]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .systemBackground
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "Cell"
        )
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var adapter = CollectionViewAdapter(
        numberOfItems: { [weak self] collectionView, section in
            return self?.items.count ?? 0
        },
        cellForItem: { collectionView, indexPath in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "Cell",
                for: indexPath
            )
            
            cell.backgroundColor = .systemBlue
            return cell
        },
        didSelectItem: { [weak self] collectionView, indexPath in
            guard let self else { return }
            print("선택된 item:", self.items[indexPath.item])
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)

        // ⭐️ 오토레이아웃 제약
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
    AdapterSampleVC()
}


//
//final class CollectionViewAdapter: NSObject {
//    public typealias NumberOfItems = (_ collectionView: UICollectionView, _ section: Int) -> Int
//    public typealias CellForItem = (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell
//    public typealias DidSelectItem = (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void
//    
//    private var numberOfItems: NumberOfItems?
//    private var cellForItem: CellForItem?
//    private var didSelectItem: DidSelectItem?
//    
//    public override init() {
//        super.init()
//    }
//    
//    @discardableResult
//    public func apply(
//        numberOfItems: @escaping NumberOfItems,
//        cellForItem: @escaping CellForItem,
//        didSelectItem: DidSelectItem? = nil
//    ) -> Self {
//        self.numberOfItems = numberOfItems
//        self.cellForItem = cellForItem
//        self.didSelectItem = didSelectItem
//        return self
//    }
//    
//    public func attach(to collectionView: UICollectionView) {
//        collectionView.dataSource = self
//        collectionView.delegate = self
//    }
//}
//
//extension CollectionViewAdapter: UICollectionViewDataSource {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        numberOfItemsInSection section: Int
//    ) -> Int {
//        numberOfItems?(collectionView, section) ?? 0
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath
//    ) -> UICollectionViewCell {
//        guard let cellForItem else {
//            return UICollectionViewCell()
//        }
//        
//        return cellForItem(collectionView, indexPath)
//    }
//}
//
//private lazy var adapter = CollectionViewAdapter()
//    .apply(
//        numberOfItems: { [weak self] collectionView, section in
//            self?.items.count ?? 0
//        },
//        cellForItem: { collectionView, indexPath in
//            let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: "Cell",
//                for: indexPath
//            )
//            
//            cell.backgroundColor = .systemBlue
//            return cell
//        },
//        didSelectItem: { [weak self] collectionView, indexPath in
//            guard let self else { return }
//            print("선택된 item:", self.items[indexPath.item])
//        }
//    )
