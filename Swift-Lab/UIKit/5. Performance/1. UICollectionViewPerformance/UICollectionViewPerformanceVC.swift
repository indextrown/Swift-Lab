//
//  UICollectionViewPerformanceVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/3/26.
//

import UIKit

final class UICollectionViewPerformanceVC: UIViewController {
    
    private func itemSize(for itemsPerRow: Int,
                          spacing: CGFloat = 10,
                          sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ) -> CGSize {
        
        let itemsPerRow = CGFloat(itemsPerRow)
        
        // 셀 사이 총 간격 (아이템 개수 - 1)
        let totalSpacing = spacing * (itemsPerRow - 1)
        
        // 좌우 inset
        let totalInset = sectionInset.left + sectionInset.right
        
        // 실제 사용 가능한 너비
        let availableWidth = collectionView.bounds.width - totalInset - totalSpacing
        
        let width = floor(availableWidth / itemsPerRow) // 소수점 버림 (깨짐 방지)
        
        return CGSize(width: width, height: width)
    }
    
    struct ItemModel {
        let id: Int
        let imageURL: URL
    }
    
    private func generateRandomImage() -> UIImage {
        
        let size = CGSize(width: 200, height: 200)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        
        let context = UIGraphicsGetCurrentContext()!
        
        let randomColor = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1
        )
        
        context.setFillColor(randomColor.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }

    private lazy var data: [ItemModel] = {
        (1...200).map { number in
            let url = URL(string: "https://picsum.photos/300/300?random=\(number)")!
            return ItemModel(id: number, imageURL: url)
        }
    }()
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
    }
    
    func setupDelegate() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(PerformanceCell.self, forCellWithReuseIdentifier: PerformanceCell.reuseIdentifier)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - DataSource
extension UICollectionViewPerformanceVC: UICollectionViewDataSource {
    
    /// 섹션 개수
    /// 기본값은 1이지만, 명시적으로 작성하면 구조 파악이 쉬움
    /// 여러 섹션을 사용할 경우 여기서 개수를 반환
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// 특정 섹션에 표시할 아이템(셀)의 개수 반환
    /// 이 값만큼 cellForItemAt이 호출됨
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    /// 실제 셀을 생성(재사용)하고 데이터 바인딩하는 메서드
    /// 가장 중요한 DataSource 메서드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 재사용 큐에서 셀을 꺼냄
        // 성능 최적화를 위해 기존 셀을 재사용
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PerformanceCell.reuseIdentifier, for: indexPath) as? PerformanceCell else { return UICollectionViewCell() }
        
        let item = data[indexPath.item]
        // indexPath.item → 현재 셀의 위치
        // 해당 위치의 데이터를 셀에 전달
        cell.configure(text: "\(item.id)",
                       imageURL: item.imageURL)
        return cell
    }
}

// MARK: - Delegate
extension UICollectionViewPerformanceVC: UICollectionViewDelegate {
    /// 셀이 선택되었을 때 호출
    /// 화면 이동, 상세 페이지 push 등에 사용
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item + 1)번 cell 클릭")
    }
    
    /// 선택 가능 여부 제어
    /// 특정 조건에서 선택 막을 때 사용
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// 선택 해제 감지
    /// multiple selection일 때 유용
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    /// 스크롤 될 때마다 호출
    /// 무한 스크롤, 네비게이션 애니메이션 등에 사용
    /// UICollectionView는 UIScrollView를 상속하므로 이 메서드 사용 가능
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

// MARK: - 셀 크기
extension UICollectionViewPerformanceVC: UICollectionViewDelegateFlowLayout {
    
    /// 셀 하나의 크기 설정
    /// 레이아웃 계산은 bounds 기준이 안전함
    /// 현재는 2열 그리드 구성
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // frame은 superview 좌표 기준
        // bounds는 자기 내부 좌표 기준
        // 좌우 간격 + 셀 사이 간격 고려
        return itemSize(for: 3)
    }
    
    /// 행과 행 사이의 세로 간격
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    /// 같은 행에서 셀 사이의 가로 간격
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    /// 섹션 전체 여백
    /// 테두리 padding 개념
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

// urlsession은 내부적으로 urlcache를 사용함
//extension UICollectionViewPerformanceVC: UICollectionViewDataSourcePrefetching {
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        prefetchItemsAt indexPaths: [IndexPath]) {
//        
//        for indexPath in indexPaths {
//            let url = data[indexPath.item].imageURL
//            
//            // 🔥 그냥 요청만 날림
//            URLSession.shared.dataTask(with: url).resume()
//        }
//    }
//}
