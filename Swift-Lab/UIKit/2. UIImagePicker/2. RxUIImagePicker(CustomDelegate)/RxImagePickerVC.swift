//
//  RxImagePickerVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/22/26.
//

import UIKit
import RxSwift
import RxCocoa

final class RxImagePickerVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    let button: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Image Picker", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func bind() {

        button.rx.tap
            .flatMapLatest { [weak self] _ -> Observable<UIImage> in
                guard let self else { return .empty() }
                return self.showImageSourceActionSheet()
                    .flatMap { source in
                        return UIImagePickerController.rxPick(
                            parent: self,
                            source: source
                        )
                    }
                
            }
            .subscribe(onNext: { image in
                print("이미지:", image)
            })
            .disposed(by: disposeBag)
    }
    
    private func showImageSourceActionSheet()
    -> Observable<UIImagePickerController.SourceType> {

        return Observable.create { observer in

            let alert = UIAlertController(
                title: "이미지 선택",
                message: nil,
                preferredStyle: .actionSheet
            )

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alert.addAction(UIAlertAction(title: "카메라", style: .default) { _ in
                    observer.onNext(.camera)
                    observer.onCompleted()
                })
            }

            alert.addAction(UIAlertAction(title: "갤러리", style: .default) { _ in
                observer.onNext(.photoLibrary)
                observer.onCompleted()
            })

            alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
                observer.onCompleted()
            })

            self.present(alert, animated: true)

            return Disposables.create {
                alert.dismiss(animated: true)
            }
        }
    }
}
