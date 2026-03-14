//
//  PerformBatchVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/8/26.
//
/*
 https://ios-development.tistory.com/681
 https://skytitan.tistory.com/516
 */

import UIKit

final class PerformBatchVC: UIViewController {
    var data: [Int] = [1, 2, 3, 4, 5 ,6]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        let cv = UICollectionView(frame: .zero,
                                  collectionViewLayout: layout)
        cv.register(CustomCollectionViewCell.self,
                    forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var insertButton: UIButton = {
        let button = UIButton()
        button.setTitle("insert", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapInsertButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var insertAnimationButton: UIButton = {
        let button = UIButton()
        button.setTitle("insertAnimaton", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapAnimationInsertButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("delete", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    lazy var moveButton: UIButton = {
        let button = UIButton()
        button.setTitle("move", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 12.0
        view.backgroundColor = .systemGreen
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(collectionView)
        self.view.addSubview(stackView)
        
        [insertButton, insertAnimationButton, deleteButton, moveButton].forEach { stackView.addArrangedSubview($0) }
        
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -36)
        ])
    }
    
    @objc func didTapInsertButton(_ sender: Any) {
        data.insert(0, at: 0)
        collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
        
        data.remove(at: 6)
        collectionView.deleteItems(at: [IndexPath(item: 6, section: 0)])
    }
    
    @objc func didTapAnimationInsertButton(_ sender: Any) {
        collectionView.performBatchUpdates {
            data.insert(0, at: 0)
            collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])

            data.remove(at: 5)
            collectionView.deleteItems(at: [IndexPath(item: 5, section: 0)])
        } completion: { [weak self] _ in
            print(self?.collectionView.numberOfItems(inSection: 0) ?? -1)
        }
    }
}

extension PerformBatchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as! CustomCollectionViewCell
        cell.configure(text: String(data[indexPath.item]))
        return cell
    }
}

#Preview {
    PerformBatchVC()
}

