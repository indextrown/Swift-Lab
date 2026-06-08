//
//  PaginationVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/20/26.
//
/*
 https://ios-development.tistory.com/715
 */

import UIKit

/// 스크롤 기반 pagination 트리거 방식을 정의하는 enum입니다.
/// 컬렉션 뷰의 현재 스크롤 위치에 따라 다음 데이터를 로드할 시점을 결정합니다.
enum ScrollTrigger {
    
    /// 절대 거리 기준 트리거
    ///
    /// - Parameter value: 하단에서 떨어진 거리 (pt 단위)
    /// - Description:
    /// contentHeight - visibleHeight - value 시점에 트리거됩니다.
    ///
    /// 예:
    /// .absolute(100)
    /// → "끝에서 100pt 전에 호출"
    case absolute(CGFloat)
    
    
    /// 스크롤 진행률 기준 트리거
    ///
    /// - Parameter ratio: 0.0 ~ 1.0 사이 값
    /// - Description:
    /// 전체 스크롤 가능한 길이에서 특정 비율 지점에 도달하면 트리거됩니다.
    ///
    /// 예:
    /// .ratio(0.8)
    /// → "전체 스크롤의 80% 지점에서 호출"
    case ratio(CGFloat)
    
    
    /// 컨테이너(화면) 크기 기준 트리거
    ///
    /// - Parameter multiplier: 컨테이너 높이의 배수
    /// - Description:
    /// "남은 화면 수" 개념으로 동작합니다.
    ///
    /// 예:
    /// .relativeToContainerSize(1.0)
    /// → "한 화면 남았을 때 호출"
    ///
    /// .relativeToContainerSize(2.0)
    /// → "두 화면 남았을 때 호출"
    ///
    /// .relativeToContainerSize(0.5)
    /// → "반 화면 남았을 때 호출"
    case relativeToContainerSize(CGFloat)
}

final class PaginationVC: UIViewController {
    // MARK: - Properties
    private var items: [String] = []
    private var isLoading = false
    private var currentPage = 0
    private let pageSize = 20
    private let maxPage = 100
    var trigger: ScrollTrigger = .relativeToContainerSize(5)
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let itemWidth = (view.bounds.width - 16 - 16 - 12) / 2
        layout.itemSize = CGSize(width: itemWidth, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            PaginationCell.self,
            forCellWithReuseIdentifier: PaginationCell.reuseIdentifier
        )
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "CollectionView Pagination"
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
    /// 다음 페이지 데이터를 로드합니다.
    /// 이미 로딩 중이거나 마지막 페이지에 도달한 경우 요청하지 않습니다.
    private func loadMoreData() {
        guard !isLoading else { return }
        guard currentPage < maxPage else { return }
        
        isLoading = true
        currentPage += 1
        
        print("페이지 \(currentPage) 로딩 시작")
        
        // 네트워크 요청을 흉내 내기 위한 지연
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            let start = (self.currentPage - 1) * self.pageSize
            let newItems = (start..<(start + self.pageSize)).map { "Item \($0)" }
            
            self.items.append(contentsOf: newItems)
            self.collectionView.reloadData()
            self.isLoading = false
            
            print("페이지 \(self.currentPage) 로딩 완료")
        }
    }
}

extension PaginationVC: UICollectionViewDataSource {
    /// 섹션 내 아이템 개수를 반환
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return items.count
    }
    
    /// 각 indexPath에 해당하는 셀을 구성하여 반환
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaginationCell.reuseIdentifier,
            for: indexPath
        // UICollectionViewCell -> PaginationCell 다운캐스팅
        ) as? PaginationCell else {
            return UICollectionViewCell()
        }
        
        let item = items[indexPath.item]
        cell.configure(text: item)
        return cell
    }
}

extension PaginationVC: UICollectionViewDelegate {
    
    /// 스크롤 발생할 때마다 호출.
    /// 컬렉션 뷰 하단에 가까워지면 다음 페이지 로드를 시도.
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y          /// 0이면 맨위 -> 값 커질수록 아래로 내려감
//        let contentHeight = scrollView.contentSize.height /// 전체 콘텐츠 높이(스크롤 가능한 전체 길이)
//        let visibleHeight = scrollView.frame.height       /// 현재 화면에 보이는 높이
//        
//        // 하단에서 100pt 전에 미리 로드
//        let threshold: CGFloat = 500
//        
//        // contentHeight - visibleHeight: 스크롤 끝에 도달했을 때 offsetY값
//        // threadhold: 미리 로딩
//        // 현재 위치 > (끝 위치 - 100) == "거의 끝까지 스크롤했으면"
//        if offsetY > contentHeight - visibleHeight - threshold {
//            loadMoreData()
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y          /// 0이면 맨위 -> 값 커질수록 아래로 내려감
        let contentHeight = scrollView.contentSize.height /// 전체 콘텐츠 높이(스크롤 가능한 전체 길이)
        let visibleHeight = scrollView.frame.height       /// 현재 화면에 보이는 높이
        
        let triggerOffset: CGFloat
        switch trigger {
        case .absolute(let value):
            triggerOffset = contentHeight - visibleHeight - value
            
        case .ratio(let ratio):
            // 비율 기반 (예: 0.8 → 80% 지점)
            let scrollableHeight = contentHeight - visibleHeight
            triggerOffset = scrollableHeight * ratio
            
        case .relativeToContainerSize(let multiplier):
            let scrollableHeight = contentHeight - visibleHeight
            
            // 남은 거리 기준으로 계산
            // 끝에서 multiplier * visiableHeight만큼 떨어진 지점
            triggerOffset = scrollableHeight - (visibleHeight * multiplier)
        }

        
        // contentHeight - visibleHeight: 스크롤 끝에 도달했을 때 offsetY값
        // threadhold: 미리 로딩
        // 현재 위치 > (끝 위치 - 100) == "거의 끝까지 스크롤했으면"
        if offsetY > triggerOffset {
            loadMoreData()
        }
    }
}
