////
////  BasicAdapterVC.swift
////  Swift-Lab
////
////  Created by 김동현 on 4/28/26.
////
//
//import UIKit
//
//final class BasicAdapterVC: UIViewController {
//    private let items: [AnyComponent] = [
//        AnyComponent(NumberComponent(value: 1)),
//        AnyComponent(MessageComponent(value: "컴포넌트마다 셀 타입이 달라도 하나의 배열로 다룰 수 있어요.")),
//        AnyComponent(NumberComponent(value: 42)),
//        AnyComponent(MessageComponent(value: "VC는 화면 구성에만 집중하고, 셀 등록과 설정은 어댑터가 맡습니다.")),
//        AnyComponent(NumberComponent(value: 128)),
//        AnyComponent(MessageComponent(value: "type erasure로 heterogeneous collection을 만드는 가장 기본 예시입니다."))
//    ]
//
//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 12
//        layout.minimumInteritemSpacing = 12
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 32, right: 20)
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .clear
//        collectionView.alwaysBounceVertical = true
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//
//    private lazy var adapter = BasicCollectionViewAdapter(items: items)
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = "Basic Adapter"
//        view.backgroundColor = .systemGray6
//
//        view.addSubview(collectionView)
//
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//
//        adapter.attach(to: collectionView)
//    }
//}
//
//#Preview {
//    BasicAdapterVC()
//}
