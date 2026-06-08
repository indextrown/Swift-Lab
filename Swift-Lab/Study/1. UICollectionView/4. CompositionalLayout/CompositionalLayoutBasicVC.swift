//
//  CompositionalLayoutBasicVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/23/26.
//

import UIKit

enum MySection {
    case first([FirstItem])
    case second([SecondItem])
    
    struct FirstItem {
        let value: String
    }
    
    struct SecondItem {
        let value: String
    }
}

final class CompositionalLayoutBasicVC: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = Self.makeLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.register(
            MyCell.self,
            forCellWithReuseIdentifier: MyCell.reuseIdentifier
        )
        collectionView.register(
            MySectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MySectionHeaderView.reuseIdentifier
        )
        collectionView.register(
            MySectionFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: MySectionFooterView.reuseIdentifier
        )
        return collectionView
    }()
    
    private let sections: [MySection] = [
        .first((1...30).map(String.init).map(MySection.FirstItem.init(value:))),
        .second((31...60).map(String.init).map(MySection.SecondItem.init(value:))),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        setupConstraints()
    }

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return makeThreeColumnSection()
            default:
                return makeSingleColumnSection()
            }
        }
    }
    
    private func setupConstraints() {
        self.view.addSubview(self.collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
}

// MARK: - Datasource
extension CompositionalLayoutBasicVC: UICollectionViewDataSource {
    
    // 섹션이 몇개인가
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    // 특정 섹션 안에 셀이 몇개인가(required)
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {

        switch sections[section] {
        case .first(let items): // 첫 섹션
            return items.count
        case .second(let items): // 두번째 섹션
            return items.count
        }
    }
    
    // 실제 셀을 만들어서 반환하는 함수(required)
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        // 재사용 셀 꺼내기 (이미 만들어진 셀 재사용)
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyCell.reuseIdentifier,
            for: indexPath
        ) as! MyCell
        
        // indexPath.section → 몇 번째 섹션인지
        // indexPath.item → 해당 섹션 안에서 몇 번째 아이템인지
        switch self.sections[indexPath.section] {
        case .first(let items):
            cell.configure(text: items[indexPath.item].value)
        case .second(let items):
            cell.configure(text: items[indexPath.item].value)
        }
        return cell
    }

}

// MARK: - Compositional
extension CompositionalLayoutBasicVC {
    private static func makeThreeColumnSection() -> NSCollectionLayoutSection {
        let inset: CGFloat = 6

        // Item: "셀 1개"의 크기를 정의
        // 가로를 1/3로 줬기 때문에 한 줄에 3개가 들어감
        // 세로는 group 높이를 그대로 따라감
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // 셀끼리 너무 붙어 보이지 않도록 각 셀 내부 여백 추가
        item.contentInsets = NSDirectionalEdgeInsets(
            top: inset,
            leading: inset,
            bottom: inset,
            trailing: inset
        )

        // Group: "한 줄"의 크기를 정의
        // width 1.0 = 컬렉션뷰 가로 전체를 사용
        // height 100 = 한 줄 높이를 100pt로 고정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100)
        )
        // 가로 그룹 안에 item 3개를 배치
        // item의 width가 1/3 이므로 결과적으로 한 줄 3칸 레이아웃이 됨
        /*
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item, item]
        )
         */
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 3
        )

        // Section: 이런 "한 줄(group)" 들의 묶음
        // collectionView의 첫 번째 섹션 전체 레이아웃이라고 생각하면 됨
        let section = NSCollectionLayoutSection(group: group)
        // 섹션 바깥쪽 여백
        section.contentInsets = NSDirectionalEdgeInsets(
            top: inset,
            leading: inset,
            bottom: 12,
            trailing: inset
        )
        section.boundarySupplementaryItems = [
            makeSectionHeader(),
            makeSectionFooter()
        ]
        return section
    }

    private static func makeSingleColumnSection() -> NSCollectionLayoutSection {
        let inset: CGFloat = 8

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: inset,
            bottom: inset,
            trailing: inset
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: inset,
            trailing: 0
        )
        section.boundarySupplementaryItems = [
            makeSectionHeader(),
            makeSectionFooter()
        ]
        return section
    }

    // NSCollectionLayoutBoundarySupplementaryItem: 레이아웃 단계
    // - 헤더/푸터를 어디에, 어떤 크기로 놓을지
    // - 레이아웃 설정
    private static func makeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    private static func makeSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(32)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
    }
}

// MARK: - SupplementaryView
extension CompositionalLayoutBasicVC {
    // 컬렉션뷰에서 요청한 헤더/푸터(supplementary view)를 생성해서 반환하는 함수
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        // elementKindSectionFooter
        // - 이 supplementary view가 헤더라는 kind 값
        // - 즉 실제 헤더 뷰를 등록하고 dequeue할 때 쓰는 식별자
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MySectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as! MySectionHeaderView
            header.configure(text: headerTitle(for: indexPath.section))
            return header

        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MySectionFooterView.reuseIdentifier,
                for: indexPath
            ) as! MySectionFooterView
            footer.configure(text: footerTitle(for: indexPath.section))
            return footer

        default:
            return UICollectionReusableView()
        }
    }

    private func headerTitle(for section: Int) -> String {
        switch sections[section] {
        case .first:
            return "First Section Header"
        case .second:
            return "Second Section Header"
        }
    }

    private func footerTitle(for section: Int) -> String {
        switch sections[section] {
        case .first:
            return "First Section Footer"
        case .second:
            return "Second Section Footer"
        }
    }
}
