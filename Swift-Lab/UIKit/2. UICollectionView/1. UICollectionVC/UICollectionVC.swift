//
//  UICollectionVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/22/26.
//

/*
 https://developer.apple.com/documentation/uikit/uicollectionview
 https://engineering.linecorp.com/ko/blog/ios-refactoring-uicollectionview-1
 https://lsh424.tistory.com/52
 https://ios-development.tistory.com/901
 https://sookim-1.tistory.com/entry/iOS-iOS-14이상에서-UICollectionView-사용하기
 https://apple-apeach.tistory.com/25
 
 datasource
 - 데이터 몇 개? 셀 뭐 보여줄래?
 
 Delegate
 - 선택, 스크롤, 이벤트
 
 FlowLayout
 - 크기, 간격, 여백
 
 Diffable
 - 데이터 변경 애니메이션 관리
 
 */
import UIKit

final class UICollectionVC: UIViewController {
    
    let data = Array(1...20)
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
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - DataSource
extension UICollectionVC: UICollectionViewDataSource {
    
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        
        // indexPath.item → 현재 셀의 위치
        // 해당 위치의 데이터를 셀에 전달
        cell.configure(text: "\(data[indexPath.item])")
        return cell
    }
}

// MARK: - Delegate
extension UICollectionVC: UICollectionViewDelegate {
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
extension UICollectionVC: UICollectionViewDelegateFlowLayout {
    
    /// 셀 하나의 크기 설정
    /// 레이아웃 계산은 bounds 기준이 안전함
    /// 현재는 2열 그리드 구성
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // frame은 superview 좌표 기준
        // bounds는 자기 내부 좌표 기준
        // 좌우 간격 + 셀 사이 간격 고려
        let width = (collectionView.bounds.width - 30) / 2
        return CGSize(width: width, height: width)
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

#Preview {
    UICollectionVC()
}
