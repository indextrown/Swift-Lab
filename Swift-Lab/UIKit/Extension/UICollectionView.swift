//
//  UICollectionView.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/23/26.
//

import UIKit

// let cell: CustomCollectionViewCell =
// collectionView.dequeue(CustomCollectionViewCell.self, for: indexPath)
extension UICollectionView {
    // 제네릭
    func dequeue<T: UICollectionViewCell>(_ cellType: T.Type,
                                       for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath) as? T else {
            fatalError("Failed to dequeue \(cellType)")
        }
        return cell
    }
}
