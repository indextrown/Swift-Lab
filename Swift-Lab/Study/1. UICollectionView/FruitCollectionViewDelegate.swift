//
//  FruitCollectionViewDelegate.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/19/26.
//

import UIKit

final class FruitCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var didSelectItem: ((Fruit) -> Void)?
    private let dataSource: FruitCollectionViewDataSource
    
    // MARK: - required
    /// 델리게이트를 생성합니다.
    /// - Parameter dataSource: 선택된 아이템의 실제 데이터를 참조하기 위한 데이터소스 객체
    init(dataSource: FruitCollectionViewDataSource) {
        self.dataSource = dataSource
        super.init()
    }
    
    // MARK: - Selection
    /// 아이템이 선택되기 직전에 호출됩니다.
    /// 선택을 허용할지 여부를 결정할 수 있습니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 선택 예정인 아이템 위치
    /// - Returns: true를 반환하면 선택을 허용하고, false를 반환하면 선택을 막습니다.
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        return true
    }
    
    /// 아이템이 선택되었을 때 호출됩니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 선택된 아이템 위치
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.item(at: indexPath)
        didSelectItem?(item)
    }
    
    /// 아이템 선택이 취소되기 직전에 호출됩니다.
    /// 선택 해제를 허용할지 여부를 결정할 수 있습니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 선택 취소 예정인 아이템 위치
    /// - Returns: true를 반환하면 선택 해제를 허용하고, false를 반환하면 취소를 막습니다.
    func collectionView(
        _ collectionView: UICollectionView,
        shouldDeselectItemAt indexPath: IndexPath
    ) -> Bool {
        return true
    }
    
    /// 아이템 선택이 취소되었을 때 호출됩니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 선택 취소된 아이템 위치
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didDeselectItemAt:", indexPath)
    }
    
    // MARK: - Highlight
    /// 아이템 하이라이트 여부를 결정합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 하이라이트 여부를 판단할 위치
    /// - Returns: 하이라이트 허용 시 true
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// 아이템이 하이라이트될 때 호출됩니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 하이라이트된 위치
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print("didHighlightItemAt:", indexPath)
    }
    
    /// 아이템 하이라이트가 해제될 때 호출됩니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 하이라이트 해제된 위치
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        print("didUnhighlightItemAt:", indexPath)
    }
    
    // MARK: - Display
    /// 셀이 화면에 표시되기 직전에 호출됩니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - cell: 표시될 셀
    ///   - indexPath: 셀의 위치
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("willDisplay cell at:", indexPath)
    }
    
    /// 셀이 화면에서 사라진 직후 호출됩니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - cell: 사라진 셀
    ///   - indexPath: 셀의 위치
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("didEndDisplaying cell at:", indexPath)
    }
    
    /// 보조 뷰가 화면에 표시되기 직전에 호출됩니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - view: 표시될 보조 뷰
    ///   - elementKind: 보조 뷰 종류
    ///   - indexPath: 위치
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        print("willDisplaySupplementaryView at:", indexPath)
    }
    
    /// 보조 뷰가 화면에서 사라졌을 때 호출됩니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - view: 사라진 보조 뷰
    ///   - elementKind: 보조 뷰 종류
    ///   - indexPath: 위치
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplayingSupplementaryView view: UICollectionReusableView,
        forElementOfKind elementKind: String,
        at indexPath: IndexPath
    ) {
        print("didEndDisplayingSupplementaryView at:", indexPath)
    }
    
    // MARK: - Menu / Actions
    /// 특정 아이템에 대해 액션 메뉴 표시가 가능한지 여부를 반환합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 대상 위치
    /// - Returns: 메뉴 표시 가능 여부
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /// 특정 액션을 수행할 수 있는지 여부를 반환합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - action: 수행할 액션
    ///   - indexPath: 대상 위치
    ///   - sender: 액션 호출자
    /// - Returns: 액션 수행 가능 여부
    func collectionView(
        _ collectionView: UICollectionView,
        canPerformAction action: Selector,
        forItemAt indexPath: IndexPath,
        withSender sender: Any?
    ) -> Bool {
        return false
    }
    
    /// 실제 액션 수행 시 호출됩니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - action: 수행할 액션
    ///   - indexPath: 대상 위치
    ///   - sender: 액션 호출자
    func collectionView(
        _ collectionView: UICollectionView,
        performAction action: Selector,
        forItemAt indexPath: IndexPath,
        withSender sender: Any?
    ) {
        print("performAction at:", indexPath)
    }
    
    // MARK: - Focus
    /// 포커스 이동이 가능한지 여부를 반환합니다.
    /// - Parameter collectionView: 컬렉션 뷰
    /// - Returns: 포커스 가능 여부
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    /// 각 아이템의 크기를 반환합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - collectionViewLayout: 현재 레이아웃 객체
    ///   - indexPath: 크기를 계산할 아이템 위치
    /// - Returns: 아이템 크기
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let padding: CGFloat = 16
        let spacing: CGFloat = 12
        let totalSpacing = padding * 2 + spacing
        let width = (collectionView.bounds.width - totalSpacing) / 2
        return CGSize(width: width, height: 100)
    }
    
    /// 섹션의 상단/좌측/하단/우측 여백을 반환합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - collectionViewLayout: 현재 레이아웃 객체
    ///   - section: 대상 섹션 번호
    /// - Returns: 섹션 inset
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    /// 같은 행 내 아이템 간의 최소 가로 간격을 반환합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - collectionViewLayout: 현재 레이아웃 객체
    ///   - section: 대상 섹션 번호
    /// - Returns: 최소 가로 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 12
    }
    
    /// 행과 행 사이의 최소 세로 간격을 반환합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - collectionViewLayout: 현재 레이아웃 객체
    ///   - section: 대상 섹션 번호
    /// - Returns: 최소 세로 간격
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 12
    }
    
    /// 섹션 헤더의 크기를 반환합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - collectionViewLayout: 현재 레이아웃 객체
    ///   - section: 대상 섹션 번호
    /// - Returns: 헤더 크기
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return .zero
    }
    
    /// 섹션 푸터의 크기를 반환합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - collectionViewLayout: 현재 레이아웃 객체
    ///   - section: 대상 섹션 번호
    /// - Returns: 푸터 크기
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        return .zero
    }
}
