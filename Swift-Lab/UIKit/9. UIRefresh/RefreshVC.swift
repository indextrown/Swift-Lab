//
//  RefreshVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/19/26.
//

import UIKit

final class RefreshVC: UIViewController {
    private var items: [Int] = Array(0..<20)
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: 60
        )
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupRefreshControl()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension RefreshVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        )
        cell.backgroundColor = .systemBlue
        return cell
    }
}

private extension RefreshVC {
    // MARK: - 당겨서 새로고침 UI
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(handleRefresh), /// action연결
            for: .valueChanged
        )
        
        /// 인디케이터 커스텀
        refreshControl.tintColor = .systemIndigo
        refreshControl.attributedTitle = NSAttributedString(
            string: "당겨서 새로고침",
            attributes: [.foregroundColor: UIColor.systemIndigo]
        )
        
        /// refreshcontrol 연결
        collectionView.refreshControl = refreshControl
    }
    
    // MARK: - 실제 데이터 갱신 로직
    @objc
    private func handleRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.items = Array(0..<Int.random(in: 10...30))
            self.collectionView.reloadData()
            sender.endRefreshing() /// 끝나면 종료
        }
    }
}

#Preview {
    RefreshVC()
}
