//
//  FruitCollectionViewDataSource.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/19/26.
//

import UIKit

final class FruitCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    private var items: [Fruit]
    
    // MARK: - required
    /// 데이터소스를 생성합니다.
    /// - Parameter items: 컬렉션 뷰에 표시할 초기 데이터 배열
    init(items: [Fruit]) {
        self.items = items
        super.init()
    }
    
    // MARK: - required
    /// 섹션의 개수를 반환하는 필수 메서드입니다.
    /// - Parameter collectionView: 데이터를 표시할 컬렉션 뷰
    /// - Returns: 섹션 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// 특정 섹션에 포함된 아이템 수를 반환하는 필수 메서드입니다.
    /// - Parameters:
    ///   - collectionView: 데이터를 표시할 컬렉션 뷰
    ///   - section: 아이템 개수를 요청받은 섹션 인덱스
    /// - Returns: 해당 섹션의 아이템 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    /// 각 indexPath에 대응하는 셀을 생성하고 구성하는 필수 메서드입니다.
    /// - Parameters:
    ///   - collectionView: 셀을 요청한 컬렉션 뷰
    ///   - indexPath: 생성할 셀의 위치 정보
    /// - Returns: 구성된 컬렉션 뷰 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FruitCell.self),
            for: indexPath
        ) as? FruitCell else {
            return UICollectionViewCell()
        }
        
        let item = items[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    // MARK: - Supplementary View
    /// 헤더/푸터 같은 보조 뷰를 생성할 때 호출됩니다.
    /// - Parameters:
    ///   - collectionView: 보조 뷰를 요청한 컬렉션 뷰
    ///   - kind: 헤더 또는 푸터 종류
    ///   - indexPath: 보조 뷰의 위치
    /// - Returns: 보조 뷰 객체
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    // MARK: - Reordering
    /// 특정 아이템이 이동 가능한지 여부를 반환합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 이동 가능 여부를 판단할 아이템 위치
    /// - Returns: 이동 가능하면 true
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /// 아이템이 실제로 이동되었을 때 데이터 배열도 함께 갱신합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - sourceIndexPath: 원래 위치
    ///   - destinationIndexPath: 이동한 위치
    func collectionView(
        _ collectionView: UICollectionView,
        moveItemAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        let movedItem = items.remove(at: sourceIndexPath.item)
        items.insert(movedItem, at: destinationIndexPath.item)
    }
    
    // MARK: - Index Titles
    /// 컬렉션 뷰 우측 인덱스 타이틀 목록을 반환합니다.
    /// 일반적인 기본 예제에서는 거의 사용되지 않습니다.
    /// - Parameter collectionView: 컬렉션 뷰
    /// - Returns: 인덱스 타이틀 배열
    func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return nil
    }
    
    /// 인덱스 타이틀 선택 시 이동할 섹션 인덱스를 반환합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - title: 선택된 인덱스 타이틀
    ///   - index: 선택된 인덱스 위치
    /// - Returns: 이동할 섹션 번호
    func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        return IndexPath(item: 0, section: index)
    }
    
    // MARK: - Helper
    /// 특정 위치의 데이터를 반환합니다.
    /// - Parameter indexPath: 조회할 위치
    /// - Returns: 해당 위치의 과일 데이터
    func item(at indexPath: IndexPath) -> Fruit {
        return items[indexPath.item]
    }
    
    /// 전체 데이터를 교체합니다.
    /// - Parameter newItems: 새로 적용할 데이터 배열
    func updateItems(_ newItems: [Fruit]) {
        self.items = newItems
    }
}
