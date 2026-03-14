//
//  DifferenceNoSectionVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/8/26.
//
// https://github.com/ra1028/DifferenceKit

import UIKit
import DifferenceKit

fileprivate struct DiffNumberItem: Differentiable {

    let id: Int

    var differenceIdentifier: Int {
        id
    }

    func isContentEqual(to source: DiffNumberItem) -> Bool {
        id == source.id
    }
}

fileprivate struct DiffNumberSection: DifferentiableSection {

    var id: Int
    var elements: [DiffNumberItem]
    
    var differenceIdentifier: Int {
        id
    }
    
    init(id: Int, elements: [DiffNumberItem]) {
        self.id = id
        self.elements = elements
    }
    
    init<C>(source: DiffNumberSection, elements: C) where C : Collection, C.Element == DiffNumberItem {
        self = source
        self.elements = Array(elements)
    }
    
    func isContentEqual(to source: DiffNumberSection) -> Bool {
        // id == source.id && elements == source.elements
        id == source.id
    }
}


final class Difference_SectionVC: UIViewController {
    private var data: [DiffNumberItem] = (1...20).map { DiffNumberItem(id: $0) }
    
    private var sections: [DiffNumberSection] = [
        DiffNumberSection(
            id: 0,
            elements: (1...5).map { DiffNumberItem(id: $0) }
        ),
        DiffNumberSection(
            id: 1,
            elements: (6...10).map { DiffNumberItem(id: $0) }
        )
    ]
    
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
                        action: #selector(addSection))
    }
    
    // btn action
    @objc
    private func addSection() {
        var newSections = sections
        let newSection = DiffNumberSection(
            id: Int.random(in: 100...200),
            elements: (1...3).map { _ in DiffNumberItem(id: Int.random(in: 100...200)) }
        )
        newSections.append(newSection)
        update(newSections: newSections)
    }
    
    // differencekit
    private func update(newSections: [DiffNumberSection]) {
        let changeset = StagedChangeset(source: sections,
                                        target: newSections)
        
        collectionView.reload(using: changeset) { data in
            self.sections = data
        }
    }
}

// MARK: - DataSource
extension Difference_SectionVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView
    ) -> Int {
        // 1
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        // data.count
        sections[section].elements.count
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
        
        // let item = data[indexPath.item]
        let item = sections[indexPath.section].elements[indexPath.item]
        
        cell.configure(text: "\(item.id)")
        
        return cell
    }
}

// MARK: - FlowLayout
extension Difference_SectionVC: UICollectionViewDelegateFlowLayout {

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
    UINavigationController(rootViewController: Difference_SectionVC())
}

