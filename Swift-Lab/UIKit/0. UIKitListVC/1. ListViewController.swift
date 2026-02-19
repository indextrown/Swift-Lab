//
//  ListViewController.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/19/26.
//

import UIKit

// MARK: - 메인 ListViewController
final class ListViewController: UIViewController {
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<MenuSection, MenuItem>!
    var menuData: [MenuSection: [MenuItem]] = [:]
    weak var navigationControllerRef: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            config.headerMode = .supplementary // 반드시 추가

        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)

        // 셀 등록
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MenuItem> { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()] // 화살표 추가
        }

        // 헤더 등록 (iOS 16+ SupplementaryRegistration)
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { supplementaryView, elementKind, indexPath in
            var content = UIListContentConfiguration.header()
            let section = MenuSection.allCases[indexPath.section]
            content.text = section.rawValue
            supplementaryView.contentConfiguration = content
        }

        // 데이터소스
        dataSource = UICollectionViewDiffableDataSource<MenuSection, MenuItem>(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }

        collectionView.delegate = self
    }

    func applyMenu(_ menu: [MenuSection: [MenuItem]]) {
        self.menuData = menu
        var snapshot = NSDiffableDataSourceSnapshot<MenuSection, MenuItem>()
        for section in MenuSection.allCases {
            let items = menu[section] ?? []
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = item.viewControllerType.init()
        vc.title = item.title
        navigationControllerRef?.pushViewController(vc, animated: true)
    }
}
