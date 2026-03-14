//
//  RxUICollectionViewPerformance.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/3/26.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class RxUICollectionViewPerformanceVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    struct ItemModel {
        let id: Int
        let imageURL: URL
    }
    
    private lazy var data: [ItemModel] = {
        (1...2000).map { number in
            let url = URL(string: "https://picsum.photos/2000/2000?random=\(number)")!
            return ItemModel(id: number, imageURL: url)
        }
    }()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let cache = ImageCache.default
        
        cache.clearMemoryCache()
        cache.clearDiskCache() { print("Done") }
    }
}

private extension RxUICollectionViewPerformanceVC {
    
    func bind() {
        
        // 🔹 delegate 연결 (FlowLayout 사용 위해 필요)
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        // 🔹 items 바인딩 (dataSource 대체)
        Observable.just(data)
            .bind(to: collectionView.rx.items(
                cellIdentifier: PerformanceImageCacheCell.reuseIdentifier,
                cellType: PerformanceImageCacheCell.self
            )) { index, item, cell in
                
                cell.configure(
                    text: "\(item.id)",
                    imageURL: item.imageURL
                )
            }
            .disposed(by: disposeBag)
        
        // 🔹 셀 선택
        collectionView.rx
            .modelSelected(ItemModel.self)
            .subscribe(onNext: { item in
                print("\(item.id)번 cell 클릭")
            })
            .disposed(by: disposeBag)
        
        // 🔹 스크롤 이벤트
        collectionView.rx
            .contentOffset
            .subscribe(onNext: { offset in
                print("스크롤 위치: \(offset.y)")
            })
            .disposed(by: disposeBag)
    }
}

private extension RxUICollectionViewPerformanceVC {
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(
            PerformanceImageCacheCell.self,
            forCellWithReuseIdentifier: PerformanceImageCacheCell.reuseIdentifier
        )
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension RxUICollectionViewPerformanceVC: UICollectionViewDelegateFlowLayout {
    
    private func itemSize(for itemsPerRow: Int,
                          spacing: CGFloat = 10,
                          sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ) -> CGSize {
        
        let itemsPerRow = CGFloat(itemsPerRow)
        let totalSpacing = spacing * (itemsPerRow - 1)
        let totalInset = sectionInset.left + sectionInset.right
        
        let availableWidth = collectionView.bounds.width - totalInset - totalSpacing
        let width = floor(availableWidth / itemsPerRow)
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize(for: 3)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
