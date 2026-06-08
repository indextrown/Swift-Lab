//
//  PrefetchingVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/20/26.
//

import UIKit

final class PrefetchingVC: UIViewController {
    
    // MARK: - Properties
    private var items: [PaginationItem] = []
    private var isLoading = false
    private let batchSize = 20
    
    /// 데이터 pagination 시점을 결정하는 트리거
    var trigger: ScrollTrigger = .relativeToContainerSize(1.0)
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let itemWidth = (view.bounds.width - 16 - 16 - 12) / 2
        layout.itemSize = CGSize(width: itemWidth, height: 120)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.isPrefetchingEnabled = true
        
        collectionView.register(
            PaginationImgCell.self,
            forCellWithReuseIdentifier: PaginationImgCell.reuseIdentifier
        )
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Pagination + Image Prefetch"
        setupCollectionView()
        loadMoreData()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Data Loading
    /// 다음 아이템 묶음을 추가합니다.
    /// 데이터 pagination은 scroll trigger 기준으로만 수행합니다.
    private func loadMoreData() {
        guard !isLoading else { return }
        isLoading = true
        
        print("데이터 추가 시작")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self else { return }
            
            let start = self.items.count
            let end = start + self.batchSize
            
            let newItems = (start..<end).map { index in
                PaginationItem(
                    id: index,
                    title: "Item \(index)",
                    imageURL: URL(string: "https://picsum.photos/300/300?random=\(index)")
                )
            }
            
            let indexPaths = (start..<end).map {
                IndexPath(item: $0, section: 0)
            }
            
            self.items.append(contentsOf: newItems)
            
            self.collectionView.performBatchUpdates({
                self.collectionView.insertItems(at: indexPaths)
            }, completion: { _ in
                self.isLoading = false
            })
            
            print("데이터 추가 완료: \(start) ~ \(end - 1)")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PrefetchingVC: UICollectionViewDataSource {
    
    /// 섹션의 아이템 개수를 반환합니다.
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        items.count
    }
    
    /// indexPath에 해당하는 셀을 구성합니다.
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaginationImgCell.reuseIdentifier,
            for: indexPath
        ) as? PaginationImgCell else {
            return UICollectionViewCell()
        }
        
        let item = items[indexPath.item]
        cell.configure(item: item)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PrefetchingVC: UICollectionViewDelegate {
    
    /// 셀이 선택되었을 때 호출됩니다.
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("선택:", items[indexPath.item].title)
    }
    
    /// 스크롤 위치를 기준으로 pagination 시점을 판단합니다.
    /// 이미지 prefetch와 별개로, 데이터 추가는 여기서만 수행합니다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.height
        
        let triggerOffset: CGFloat
        
        switch trigger {
        case .absolute(let value):
            triggerOffset = contentHeight - visibleHeight - value
            
        case .ratio(let ratio):
            let scrollableHeight = contentHeight - visibleHeight
            triggerOffset = scrollableHeight * ratio
            
        case .relativeToContainerSize(let multiplier):
            let scrollableHeight = contentHeight - visibleHeight
            let rawOffset = scrollableHeight - (visibleHeight * multiplier)
            triggerOffset = max(rawOffset, 0)
        }
        
        if offsetY > triggerOffset {
            loadMoreData()
        }
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension PrefetchingVC: UICollectionViewDataSourcePrefetching {
    
    /// 곧 표시될 셀의 이미지를 미리 준비합니다.
    /// 여기서는 데이터 pagination을 수행하지 않습니다.
    func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
    ) {
        print("image prefetch:", indexPaths.map(\.item))
        
        for indexPath in indexPaths {
            guard indexPath.item < items.count else { continue }
            guard let imageURL = items[indexPath.item].imageURL else { continue }
            
            ImageLoader.shared.prefetchImage(from: imageURL)
        }
    }
    
    /// 더 이상 필요 없는 이미지 prefetch를 취소합니다.
    func collectionView(
        _ collectionView: UICollectionView,
        cancelPrefetchingForItemsAt indexPaths: [IndexPath]
    ) {
        print("image prefetch cancel:", indexPaths.map(\.item))
        
        for indexPath in indexPaths {
            guard indexPath.item < items.count else { continue }
            guard let imageURL = items[indexPath.item].imageURL else { continue }
            
            ImageLoader.shared.cancelPrefetch(for: imageURL)
        }
    }
}
