//
//  CollectionTestVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/12/26.
//

import UIKit

struct NbSection {
    var header: String
    var footer: String
    var items: [Int]
}

final class CollectionTestVC: UIViewController {
    
    private var sections: [NbSection] = [
        NbSection(header: "짝수", footer: "짝수푸터", items: Array(1...20).filter { $0 % 2 == 0 }),
        NbSection(header: "홀수", footer: "홀수푸터", items: Array(1...20).filter { $0 % 2 == 1 })
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setup()
    }
    
//    private let collectionView = UICollectionView(
//        frame: .zero,
//        collectionViewLayout: UICollectionViewFlowLayout()
//    )
    
    private let collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flow.minimumInteritemSpacing = 10
        flow.minimumLineSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: flow)
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
    }
}

extension CollectionTestVC: UICollectionViewDataSource {
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
    func numberOfSections(in collectionView: UICollectionView
    ) -> Int {
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
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionFooterView.reuseIdentifier,
                for: indexPath
            ) as! SectionFooterView
            
            header.configure(text: sections[indexPath.section].footer)
            return header
        }
        
        
        return UICollectionReusableView()
    }
    
    
    
}

extension CollectionTestVC: UICollectionViewDelegateFlowLayout {
    // 셀 크기 지정
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let flow = collectionViewLayout
                as? UICollectionViewFlowLayout else {
            return .zero
        }
        let columns: CGFloat = 5
        let inset = flow.sectionInset.left + flow.sectionInset.right
        let spacing = flow.minimumInteritemSpacing * (columns - 1)
        let width = (collectionView.bounds.width - inset - spacing) / columns
        return CGSize(width: width, height: width)
    }
    
    // 헤더 크기 지정
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    // 푸터 크기 지정
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    // 섹션 인셋(섹션마다 다른 inset을 줄 수 있다
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        // 초기 설정값 가져오기
        return (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
    }
}

#Preview {
    CollectionTestVC()
}
