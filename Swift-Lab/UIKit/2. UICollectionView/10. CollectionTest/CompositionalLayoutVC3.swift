//
//  CompositionalLayoutVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/13/26.
//

import UIKit

final class CompositionalLayoutVC3: UIViewController {
    static let sectionSpacingKind = "section-spacing"
    private var sections: [NbSection] = [
        NbSection(header: "짝수", footer: "짝수푸터", items: Array(1...20).filter { $0 % 2 == 0 }),
        NbSection(header: "홀수", footer: "홀수푸터", items: Array(1...20).filter { $0 % 2 == 1 })
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setup()
    }
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout())
        return view
    }()
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setup() {
        collectionView.dataSource = self
        
        collectionView.register(
            CustomCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier
        )
        
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )
        
        collectionView.register(
            PaddingSectionFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: PaddingSectionFooterView.reuseIdentifier
        )
    }
}

extension CompositionalLayoutVC3: UICollectionViewDataSource {
    
    // 필수: 각 섹션의 아이템 개수
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return sections[section].items.count
    }
    
    // 필수: 셀생성
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        /// 현재 indexPath에 해당하는 데이터 가져오기
        let item = sections[indexPath.section].items[indexPath.item]
        
        /// 재사용 큐에서 셀 꺼내기
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! CustomCollectionViewCell
        
        cell.configure(text: "\(item)")
        
        return cell
    }
    
    // 섹션 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    // 헤더 / 푸터 생성
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as! SectionHeaderView
            
            header.configure(text: sections[indexPath.section].header)
            
            return header
        }
        
        if kind == UICollectionView.elementKindSectionFooter {
            
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PaddingSectionFooterView.reuseIdentifier,
                for: indexPath
            ) as! PaddingSectionFooterView
            
            footer.configure(text: sections[indexPath.section].footer)
            
            return footer
        }
        
        if kind == CompositionalLayoutVC2.sectionSpacingKind {
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "SectionSpacer",
                for: indexPath
            )
        }
        
        return UICollectionReusableView()
    }
}

#Preview {
    CompositionalLayoutVC3()
}

// MARK: - Item
extension CompositionalLayoutVC3 {
    private func makeItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0/5.0),
            heightDimension: .fractionalWidth(1.0/5.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        return item
    }
}

// MARK: - Group
extension CompositionalLayoutVC3 {
    private func makeGroup(
        item: NSCollectionLayoutItem
    ) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0/5.0)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        // item 간격
        group.interItemSpacing = .fixed(10)
        return group
    }
}

// MARK: - Section
extension CompositionalLayoutVC3 {
    private func makeSection(
        sectionIndex: Int
    ) -> NSCollectionLayoutSection {
        let item = makeItem()
        let group = makeGroup(item: item)
        let section = NSCollectionLayoutSection(group: group)
        
        /// 좌우 padding
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 10,
            bottom: 0,
            trailing: 10
        )
        
        section.boundarySupplementaryItems = [
            makeHeader(),
            makeFooter(),
        ]
        
        return section
    }
}

// MARK: - Header / Footer / Spacer
extension CompositionalLayoutVC3 {
    
    private func makeHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    
    private func makeFooter() -> NSCollectionLayoutBoundarySupplementaryItem {

        let footerHeight: CGFloat = 50
        let sectionSpacing: CGFloat = 10

        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(footerHeight + sectionSpacing)
        )

        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )

        return footer
    }
}


// MARK: - Layout
extension CompositionalLayoutVC3 {
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {
            [weak self] sectionIndex, _ in
            return self?.makeSection(sectionIndex: sectionIndex)
        }
    }
}


extension PaddingSectionFooterView: ReuseIdentifiable {}
/*
 PaddingSectionFooterView (60)
 │
 ├─ containerView (50)  ← 실제 footer UI
 │     └ label
 │
 └─ 빈 공간 (10)        ← 우리가 만든 section spacing
 */
final class PaddingSectionFooterView: UICollectionReusableView {
    private let containerView = UIView()
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(containerView)
        containerView.addSubview(label)

        containerView.backgroundColor = .clear
        label.textAlignment = .left
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let footerHeight: CGFloat = 50

        containerView.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: footerHeight
        )

        label.frame = containerView.bounds
    }

    func configure(text: String) {
        label.text = text
    }
}
