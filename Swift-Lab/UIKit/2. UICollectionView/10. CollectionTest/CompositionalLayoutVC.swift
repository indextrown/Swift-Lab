//
//  CompositionalLayoutVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/13/26.
//

import UIKit

final class CompositionalLayoutVC: UIViewController {
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
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            // 셀 크기
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0/5.0),
                heightDimension: .fractionalWidth(1.0/5.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            /// 아이템 사이 spacing
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 0
            )
            
            /// 한 줄(row == group)의 묶음
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0/5.0)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            /// 한 줄의 아이템 사이 간격
            group.interItemSpacing = .fixed(10)
            
            /// section(그룹들을 포함하는 섹션)
            let section = NSCollectionLayoutSection(group: group)
            
            /// 섹션 좌우 패딩
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 10,
                bottom: 0,
                trailing: 10
            )
            
            /// Header
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            /// Footer
            let footererSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footererSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
            
            // Section spacing용 supplementary
            let spacerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50) // 섹션 사이 간격
            )
            let spacer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: spacerSize,
                elementKind: CompositionalLayoutVC.sectionSpacingKind,
                alignment: .bottom
            )
            
            /// Header, Footer 적용
            section.boundarySupplementaryItems = [header, footer, spacer]
            return section
        }
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        collectionView.delegate = self
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
            SectionFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: SectionFooterView.reuseIdentifier
        )
        
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: CompositionalLayoutVC.sectionSpacingKind,
            withReuseIdentifier: "SectionSpacer"
        )
    }
}

extension CompositionalLayoutVC: UICollectionViewDataSource {
    
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
                withReuseIdentifier: SectionFooterView.reuseIdentifier,
                for: indexPath
            ) as! SectionFooterView
            
            footer.configure(text: sections[indexPath.section].footer)
            
            return footer
        }
        
        if kind == CompositionalLayoutVC.sectionSpacingKind {
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "SectionSpacer",
                for: indexPath
            )
        }
        
        return UICollectionReusableView()
    }
}

extension CompositionalLayoutVC: UICollectionViewDelegate {}

#Preview {
    CompositionalLayoutVC()
}
