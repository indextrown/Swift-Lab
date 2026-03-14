//
//  RxUICollectionNoRxDataSourceVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/2/26.
//

import UIKit
import RxSwift
import RxCocoa

final class RxUICollectionNoRxDataSourceVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    /// 화면에 표시할 섹션 데이터
    private var sections: [NumberSection] = [
        NumberSection(header: "짝수", items: Array(1...20).filter { $0 % 2 == 0 }),
        NumberSection(header: "홀수", items: Array(1...20).filter { $0 % 2 == 1 })
    ]
    
    /// 기본 FlowLayout 사용
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Shuffle",
            style: .plain,
            target: self,
            action: #selector(shuffle)
        )
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // 셀 등록
        collectionView.register(
            CustomCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier
        )
        
        // 헤더 등록
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )
        
        // DataSource는 UIKit 방식 유지
        collectionView.dataSource = self
    }
    
    private func bind() {
        
        // 🔥 Delegate를 Rx 방식으로 연결
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // 🔥 셀 선택 이벤트 (Rx)
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                let value = self.sections[indexPath.section].items[indexPath.item]
                print("\(value)번 cell 클릭")
            })
            .disposed(by: disposeBag)
        
        // 🔥 스크롤 감지 (Rx)
        collectionView.rx.contentOffset
            .subscribe(onNext: { offset in
                print("스크롤 위치:", offset.y)
            })
            .disposed(by: disposeBag)
    }
    
    /// 데이터 섞기
    @objc private func shuffle() {
        for i in 0..<sections.count {
            sections[i].items.shuffle()
        }
        
        collectionView.reloadData()
    }
    
}

extension RxUICollectionNoRxDataSourceVC: UICollectionViewDataSource {
    
    // 섹션 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    // 섹션 헤더 생성
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
        header.configure(text: sections[indexPath.section].header)
        return header
    }
    
    // 필수: 각 섹션의 아이템 개수
    /// 특정 섹션에 표시할 아이템(셀)의 개수 반환
    /// 이 값만큼 cellForItemAt이 호출됨
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    // 필수: 셀생성
    // 실제 셀을 생성(재사용)하고 데이터 바인딩하는 메서드
    /// 가장 중요한 DataSource 메서드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /// 현재 indexPath에 해당하는 데이터 가져오기
        let item = sections[indexPath.section].items[indexPath.item]
        
        /// 재사용 큐에서 셀 꺼내기
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        
        cell.configure(text: "\(item)")
        return cell
    }
}

extension RxUICollectionNoRxDataSourceVC: UICollectionViewDelegateFlowLayout {
    
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
    
    /// 헤더 크기 지정
    /// height가 0이면 헤더는 화면에 보이지 않는다.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    /// 섹션 전체 여백
    /// 테두리 padding 개념
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
