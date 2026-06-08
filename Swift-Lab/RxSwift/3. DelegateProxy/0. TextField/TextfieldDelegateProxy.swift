//
//  TextfieldDelegateProxy.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/21/26.
//
/*
 [Delegate Proxy]
 - https://ios-development.tistory.com/152
 */

import UIKit
import RxSwift
import RxCocoa

final class TextfieldDelegateProxy: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var uiTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "글자를 입력하세요."
        textField.backgroundColor = .lightGray
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad:", ObjectIdentifier(self))
        setupUI()
        bind()
    }
    
    deinit {
        print("deinit:", ObjectIdentifier(self))
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(uiTextField)
        
        NSLayoutConstraint.activate([
            uiTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            uiTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            uiTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func bind() {
        uiTextField.rx.shouldBeginEditing
            .subscribe(onNext: {
                print("편집 시작 직전")
            })
            .disposed(by: disposeBag)

        uiTextField.rx.didBeginEditing
            .subscribe(onNext: {
                print("편집 시작됨")
            })
            .disposed(by: disposeBag)
        
        uiTextField.rx.shouldEndEditing
            .subscribe(onNext: {
                print("편집 종료 직전")
            })
            .disposed(by: disposeBag)
        
        uiTextField.rx.shouldReturn
            .subscribe(onNext: { [weak self] in
                self?.uiTextField.resignFirstResponder()
                print("리턴 키 눌림")
            })
            .disposed(by: disposeBag)
    }
}

class RxUITextFieldDelegateProxy: DelegateProxy<UITextField, UITextFieldDelegate>, DelegateProxyType, UITextFieldDelegate {
    
    // "UITextField에는 이 Proxy를 써라" 라고 등록하는 함수
    // UITextField가 나오면 IndexUITextFieldDelegateProxy를 만들어라
    static func registerKnownImplementations() {
        self.register { (textField) -> RxUITextFieldDelegateProxy in
            RxUITextFieldDelegateProxy(parentObject: textField, delegateProxy: self)
        }
    }
    
    // 현재 UITextField의 delegate가 누구냐?
    static func currentDelegate(for object: UITextField) -> (any UITextFieldDelegate)? {
        object.delegate
    }
    
    // delegate를 교체하는 역할
    static func setCurrentDelegate(_ delegate: (any UITextFieldDelegate)?, to object: UITextField) {
        object.delegate = delegate
    }
    
    /// 편집 시작 허용 여부를 묻는 delegate 메서드가 호출될 때 방출됩니다.
    let shouldBeginEditingSubject = PublishSubject<Void>()

    /// 편집이 실제로 시작된 뒤 호출될 때 방출됩니다.
    let didBeginEditingSubject = PublishSubject<Void>()
    
    /// 편집 종료 허용 여부를 묻는 delegate 메서드가 호출될 때 방출됩니다.
    let shouldEndEditingSubject = PublishSubject<Void>()
    
    /// `textFieldShouldReturn(_:)`가 호출될 때 이벤트를 방출합니다.
    let shouldReturnSubject = PublishSubject<Void>()
    
    /// 편집을 시작해도 되는지 UIKit이 물을 때 호출됩니다.
    /// Proxy가 직접 이벤트를 방출하고, 원래 delegate가 있으면 그 반환값을 그대로 전달합니다.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        shouldBeginEditingSubject.onNext(())
        return (_forwardToDelegate?
            .textFieldShouldBeginEditing?(textField)) ?? true
    }

    /// 편집이 실제로 시작된 뒤 호출됩니다.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditingSubject.onNext(())
        _forwardToDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    /// 편집을 종료해도 되는지 UIKit이 물을 때 호출됩니다.
    /// Proxy가 직접 이벤트를 방출하고, 원래 delegate가 있으면 그 반환값을 그대로 전달합니다.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        shouldEndEditingSubject.onNext(())
        return (_forwardToDelegate?
            .textFieldShouldEndEditing?(textField)) ?? true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturnSubject.onNext(())
        return true
    }
}

extension Reactive where Base: UITextField {
    private var proxy: RxUITextFieldDelegateProxy {
        RxUITextFieldDelegateProxy.proxy(for: base)
    }
    
    // var delegate
    var delegate: DelegateProxy<UITextField, UITextFieldDelegate> {
        proxy
    }
    
    // MARK: - Should Begin Editing
    /// 텍스트 필드가 편집을 시작하기 직전에 호출되는 Observable입니다.
    ///
    /// - Note: 이 이벤트는 `textFieldShouldBeginEditing(_:)` 호출 시점에 방출됩니다.
    var shouldBeginEditing: Observable<Void> {
        proxy.shouldBeginEditingSubject.asObservable()
    }

    // MARK: - Did Begin Editing
    /// 텍스트 필드가 실제로 편집 상태에 들어간 뒤 호출되는 Observable입니다.
    var didBeginEditing: Observable<Void> {
        proxy.didBeginEditingSubject.asObservable()
    }
    
    // MARK: - Should End Editing
    /// 텍스트 필드가 편집을 끝내기 직전에 호출되는 Observable입니다.
    ///
    /// - Note: 이 이벤트는 `textFieldShouldEndEditing(_:)` 호출 시점에 방출됩니다.
    var shouldEndEditing: Observable<Void> {
        proxy.shouldEndEditingSubject.asObservable()
    }
    
    var shouldReturn: Observable<Void> {
        proxy.shouldReturnSubject.asObservable()
    }
}


