////
////  LightCollectionViewAdapter.swift
////  Swift-Lab
////
////  Created by 김동현 on 4/28/26.
////
//
//import UIKit
//
//final class LightCollectionViewAdapter: NSObject {
//    private let items: [AnyComponent]
//    
//    init(items: [AnyComponent]) {
//        self.items = items
//    }
//    
//    func attach(to collectionView: UICollectionView) {
//        register(on: collectionView)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//    }
//
//    private func register(on collectionView: UICollectionView) {
//        collectionView.register(
//            ComponentContainerCell.self,
//            forCellWithReuseIdentifier: ComponentContainerCell.reuseIdentifier
//        )
//    }
//}
//
//extension LightCollectionViewAdapter: UICollectionViewDataSource {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        numberOfItemsInSection section: Int
//    ) -> Int {
//        return items.count
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath
//    ) -> UICollectionViewCell {
//        let component = items[indexPath.item]
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: ComponentContainerCell.reuseIdentifier,
//            for: indexPath
//        ) as! ComponentContainerCell
//        
//        cell.render(component: component)
//        return cell
//    }
//}
//
//extension LightCollectionViewAdapter: UICollectionViewDelegateFlowLayout {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//        let horizontalInset: CGFloat = 40
//        let width = collectionView.bounds.width - horizontalInset
//        return CGSize(width: width, height: 150)
//    }
//}
