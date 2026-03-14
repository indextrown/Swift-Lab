//
//  DifferenceNoSectionVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/8/26.
//
// https://github.com/ra1028/DifferenceKit

import UIKit
import DifferenceKit

//fileprivate struct NumberItem: Differentiable {
//    typealias DifferenceIdentifier = Int
//    
//    let id: Int
//    var differenceIdentifier: Int
//    
//    init(id: Int) {
//        self.id = id
//        self.differenceIdentifier = id
//    }
//
//    func isContentEqual(to source: NumberItem) -> Bool {
//        id == source.id
//    }
//}

fileprivate struct NumberItem: Differentiable {

    let id: Int

    var differenceIdentifier: Int {
        id
    }

    func isContentEqual(to source: NumberItem) -> Bool {
        id == source.id
    }
}

final class DifferenceNoSectionVC: UIViewController {
    private var data: [NumberItem] = (1...20).map { NumberItem(id: $0) }
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
        setupDelegate()
    }
    
    private func setupDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        // register
        collectionView.register(
            CustomCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier
        )
        
        // constraint
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // button
    private func setupButton() {
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(title: "Add",
                        style: .plain,
                        target: self,
                        action: #selector(addItem))
    }
    
    // btn action
    @objc
    private func addItem() {
        var newData = data
        let newValue = Int.random(in: 100...200)
        newData.append(NumberItem(id: newValue))
        update(newData: newData)
    }
    
    // differencekit
    private func update(newData: [NumberItem]) {
        let changeset = StagedChangeset(source: data,
                                        target: newData)
        
        collectionView.reload(using: changeset) { data in
            self.data = data
        }
    }
}

// MARK: - DataSource
extension DifferenceNoSectionVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView
    ) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = data[indexPath.item]
        
        cell.configure(text: "\(item.id)")
        
        return cell
    }
}

// MARK: - FlowLayout
extension DifferenceNoSectionVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (collectionView.bounds.width - 30) / 2
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

#Preview {
    UINavigationController(rootViewController: DifferenceNoSectionVC())
}
