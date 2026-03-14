//
//  RxUICollectionVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/22/26.
//

/*
 https://apple-apeach.tistory.com/27
 */
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class RxUICollectionAnimatedDataSourceVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let sections = BehaviorRelay<[AnimatedNumberSection]>(value: [
        AnimatedNumberSection(
            header: "짝수",
            items: Array(1...20)
                .filter { $0 % 2 == 0 }
                .map { AnimatedNumberItem(id: $0, value: $0) }
        ),
        AnimatedNumberSection(
            header: "홀수",
            items: Array(1...20)
                .filter { $0 % 2 == 1 }
                .map { AnimatedNumberItem(id: $0, value: $0) }
        )
    ])
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(title: "Shuffle",
                        style: .plain,
                        target: self,
                        action: #selector(shuffle))
        
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // cell 등록
        collectionView.register(
            CustomCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier
        )
        
        // 설명 필요
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func bind() {
        
        // RxCollectionViewSectionedReloadDataSource   애니메이션 없음
        // RxCollectionViewSectionedAnimatedDataSource 애니메이션 있음
        let dataSource =
        RxCollectionViewSectionedAnimatedDataSource<AnimatedNumberSection>(
            animationConfiguration: AnimationConfiguration(
                insertAnimation: .automatic,
                reloadAnimation: .automatic,
                deleteAnimation: .automatic
            ),
            configureCell: { dataSource, collectionView, indexPath, item in
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as! CustomCollectionViewCell
                
                cell.configure(text: "\(item.value)")
                return cell
            },
            
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                
                guard kind == UICollectionView.elementKindSectionHeader else {
                    return UICollectionReusableView()
                }
                
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                    for: indexPath
                ) as! SectionHeaderView
                
                let section = dataSource.sectionModels[indexPath.section]
                header.configure(text: section.header)
                
                return header
            }
        )
        
        sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // didSelect
        collectionView.rx.modelSelected(Int.self)
            .bind(onNext: { value in
                print("\(value)번 cell 클릭")
            })
            .disposed(by: disposeBag)
        
        // indexPath
        collectionView.rx.itemSelected
            .bind(onNext: { indexPath in
                print("indexPath: \(indexPath)")
            })
            .disposed(by: disposeBag)
        
        // flowlayout delegate
        // Rx에서는 delegate 직접 연결 대신 setDelegate 사용
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // 스크롤 감지
        collectionView.rx.contentOffset
            .bind(onNext: { offset in
                // 무한스크롤 처리 가능
                print("스크롤 위치:", offset.y)
            })
            .disposed(by: disposeBag)
    }
    
    // 랜덤 섞기
//    @objc private func shuffle() {
//        var current = sections.value
//        
//        for i in 0..<current.count {
//            current[i].items.shuffle()
//        }
//        
//        current[0].items.reverse()
//        sections.accept(current)
//    }
    @objc private func shuffle() {
        var current = sections.value
        
        // 첫 아이템 제거
        let removed = current[0].items.removeFirst()
        
        // 맨 뒤에 다시 추가
        current[0].items.append(removed)
        
        sections.accept(current)
    }
}

/*
 Rx는 DataSource/Delegate 이벤트를 Observable로 바꿔주는 거라
 레이아웃은 그대로 extension 유지하면 됨
 */
extension RxUICollectionAnimatedDataSourceVC: UICollectionViewDelegateFlowLayout {
    
    /// 각 셀(Item)의 크기를 결정하는 메서드
    /// - 한 줄에 2개씩 배치하기 위해 컬렉션뷰 너비에서 여백을 뺀 뒤 2로 나눔
    /// - 반환값이 셀의 최종 size가 됨
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // let width = (collectionView.bounds.width - 30) / 2
        let itemsPerRow: CGFloat = 5
        let spacing: CGFloat = 10
        let inset: CGFloat = 10 * 2 // left + right
        
        let totalSpacing = spacing * (itemsPerRow - 1)
        
        let availableWidth = collectionView.bounds.width - inset - totalSpacing
        let width = availableWidth / itemsPerRow
        return CGSize(width: width, height: width)
    }
    
    /// 같은 섹션에서 "줄과 줄 사이" 간격 (세로 방향 간격)
    /// - vertical scroll 기준이면 위아래 간격
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    /// 같은 줄 안에서 "셀과 셀 사이" 가로 간격
    /// - 한 줄에 여러 개 있을 때 좌우 간격
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    /// 섹션의 전체 여백 (Section 바깥 패딩)
    /// - top: 섹션 위 여백
    /// - left/right: 양쪽 여백
    /// - bottom: 섹션 아래 여백
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    /// 섹션 헤더의 크기를 결정
    /// - width는 보통 컬렉션뷰 전체 너비
    /// - height가 0이면 헤더가 안 보임
    /// - 이 값이 있어야 header가 화면에 렌더링됨
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

#Preview {
    RxUICollectionAnimatedDataSourceVC()
}
