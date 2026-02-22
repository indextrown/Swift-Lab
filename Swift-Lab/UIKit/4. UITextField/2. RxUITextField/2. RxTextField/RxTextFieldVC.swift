//
//  RxTextFieldVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/22/26.
//

import UIKit
import RxSwift

final class RxTextFieldVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private lazy var uiTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "글자를 입력하세요."
        textField.backgroundColor = .lightGray
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(uiTextField)
        NSLayoutConstraint.activate([
            uiTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bind() {
        uiTextField.rx.didBeginEditing
            .subscribe(onNext: {
                print("🟢 편집 시작")
            })
            .disposed(by: disposeBag)
        
        uiTextField.rx.didEndEditing
            .subscribe(onNext: {
                print("🔴 편집 종료")
            })
            .disposed(by: disposeBag)
        
        uiTextField.rx.shouldReturn
            .subscribe(onNext: { [weak self] in
                print("⏎ return 눌림")
                self?.uiTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        uiTextField.rx.shouldChangeCharacters
            .subscribe(onNext: { range, replacement in
                print("✏️ 입력 변경: \(replacement)")
            })
            .disposed(by: disposeBag)
        
        uiTextField.rx.shouldEndEditing
            .subscribe(onNext: {
                print("⚠️ editing 끝나려고 함")
            })
            .disposed(by: disposeBag)
    }
}


