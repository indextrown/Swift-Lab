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

final class RxUICollectionVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let items = BehaviorRelay<[Int]>(value: Array(1...20))
    
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(
            CustomCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier
        )
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func bind() {
        items
            .bind(to: collectionView.rx.items(cellIdentifier: CustomCollectionViewCell.reuseIdentifier,
                                              cellType: CustomCollectionViewCell.self)) { index, element, cell in
                // element = 현재 데이터
                cell.configure(text: "\(element)")
            }
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
}

/*
 Rx는 DataSource/Delegate 이벤트를 Observable로 바꿔주는 거라
 레이아웃은 그대로 extension 유지하면 됨
 */
extension RxUICollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width - 30) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

#Preview {
    RxUICollectionVC()
}
