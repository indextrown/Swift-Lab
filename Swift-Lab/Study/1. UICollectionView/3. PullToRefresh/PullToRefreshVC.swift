//
//  PullToRefreshVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/20/26.
//

import UIKit

final class PullToRefreshVC: UIViewController {
    
    private var items: [String] = (0..<20).map { "Item \($0)" }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.register(
            PullToRefreshCell.self,
            forCellWithReuseIdentifier: PullToRefreshCell.reuseIdentifier
        )
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Pull To Refresh"
        
        setupCollectionView()
        setupRefreshControl()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .systemIndigo
        refreshControl.attributedTitle = NSAttributedString(
            string: "당겨서 새로고침",
            attributes: [.foregroundColor: UIColor.systemIndigo]
        )
        
        collectionView.refreshControl = refreshControl
    }
    
    @objc
    private func handleRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self else { return }
            
            self.items = (0..<Int.random(in: 10...30)).map { "New Item \($0)" }
            self.collectionView.reloadData()
            sender.endRefreshing()
        }
    }
}

extension PullToRefreshVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PullToRefreshCell.reuseIdentifier,
            for: indexPath
        ) as? PullToRefreshCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(text: items[indexPath.item])
        return cell
    }
}

#Preview {
    PullToRefreshVC()
}
