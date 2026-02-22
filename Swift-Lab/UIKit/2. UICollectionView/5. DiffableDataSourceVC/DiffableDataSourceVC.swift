//
//  DiffableDataSourceVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/23/26.
//

import UIKit

final class DiffableVC: UIViewController {
    enum Section {
        case even
        case odd
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        setupUI()
        configureDataSource()
        applySnapshot()
        
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(title: "Shuffle",
                        style: .plain,
                        target: self,
                        action: #selector(shuffle))
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(
            CustomCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier
        )
        
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
            cell.configure(text: "\(item)")
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                                                                         for: indexPath) as! SectionHeaderView
            
            // snapshot에서 section 가져오기
            let snapshot = self.dataSource.snapshot()
            let section = snapshot.sectionIdentifiers[indexPath.section]
            
            switch section {
            case .even:
                header.configure(text: "짝수")
            case .odd:
                header.configure(text: "홀수")
            }
            
            return header
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.even, .odd])
        snapshot.appendItems(Array(1...20).filter { $0 % 2 == 0 }, toSection: .even)
        snapshot.appendItems(Array(1...20).filter { $0 % 2 != 0 }, toSection: .odd)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func shuffle() {
        var snapshot = dataSource.snapshot()
        
        // 현재 데이터 가져오기
        let evenItems = snapshot.itemIdentifiers(inSection: .even).shuffled()
        let oddItems = snapshot.itemIdentifiers(inSection: .odd).shuffled()
        
        // 기존 아이템 제거
        snapshot.deleteAllItems()
        
        // 다시 섹션 추가
        snapshot.appendSections([.even, .odd])
        
        // 섞인 아이템 다시 추가
        snapshot.appendItems(evenItems, toSection: .even)
        snapshot.appendItems(oddItems, toSection: .odd)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension DiffableVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // let width = (collectionView.bounds.width - 30) / 2
        let itemsPerRow: CGFloat = 5
        let spacing: CGFloat = 10
        let inset: CGFloat = 10 * 2 // left + right
        
        let totalSpacing = spacing * (itemsPerRow - 1)
        
        let availableWidth = collectionView.bounds.width - inset - totalSpacing
        let width = availableWidth / itemsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

#Preview {
    DiffableVC()
}
