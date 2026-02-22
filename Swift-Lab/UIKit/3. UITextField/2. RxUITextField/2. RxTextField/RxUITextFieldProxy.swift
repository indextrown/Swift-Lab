//
//  RxUITextFieldProxy.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/22/26.
//

import RxSwift
import RxCocoa // DelegateProxy
import UIKit

/*
 UITextField의 delegate를 가로채서 delegate 메서드를 Observable로 바꿔주는 중간 브로커
 
 rx는 아래처럼 여러 Observable을 만들 수 있어야 한다
 - textField.rx.text
 - textField.rx.controlEvent(.editingChanged)
 => 그래서 RxCocoa는 delegate 직접 쓰는 대신 DelegateProxy라는 중간 객체를 끼워 넣는다
 
 [원래 구조]
 UITextField
     ↓
 delegate (ViewController)
 
 [Rx 구조]
 - Proxy가 가로채고 Observable로 흘려보낸 뒤
 - 필요하면 원래 delegate로 전달
 UITextField
     ↓
 DelegateProxy (Rx가 만든 객체)
     ↓
 기존 delegate (ViewController)
 
 [분석]
 DelegateProxy<UITextField, UITextFieldDelegate> ==> DelegateProxy<Owner, Delegate>
 - UITextField의 delegate를 대신 관리하겠다
 
 DelegateProxyType
 - 프로토콜 채택으로 Rx가 이 Proxy를 등록하고 사용할 수 있도록 멧드 3ㅐ를 구현해야 한다
 
 registerKnownImplementations
 - "UITextField에는 이 Proxy를 써라" 라고 등록하는 함수
 - UITextField가 나오면 RxUITextFieldProxy를 만들어라
 
 currentDelegate(for:)
 - 현재 UITextField의 delegate가 누구냐?
 
 setCurrentDelegate(_:to:)
 - delegate를 교체하는 역할
 
 [예제]
 사용자가 아래처럼 사용한다면
 textField.rx.delegate
 
 1. registerKnownImplementations 확인
 2. Proxy 생성
 3. 기존 delegate 저장
 4. delegate를 Proxy로 교체
 
 [methodInvoked]
 - Delegate 메서드가 호출되는 순간을 Observable로 감지하는 기능
 
 [엔터 누름]
 UIKit
  ↓
 Proxy.textFieldShouldReturn()
  ↓
 _sentMessage → Observable 방출
  ↓
 forwardToDelegate → (있으면 실행)
  ↓
 return true
  ↓
 UIKit 계속 진행
  ↓
 editing 종료
  ↓
 didEndEditing 호출
 
 [DelegateProxy는 기본적으로 자동 Forwarding을 지원함]
 - Proxy가 메서드를 직접 구현하지 않아도 괜찮음
 - 하지만 Should 계열은 반환값이 필요해서 Proxy가 반환해준 후 UIKit이 사용해야함
 => 반환값이 있어서 Proxy가 직접 구현해줘야 한다”
 */
class RxUITextFieldDelegateProxy: DelegateProxy<UITextField, UITextFieldDelegate>, DelegateProxyType, UITextFieldDelegate {
    static func registerKnownImplementations() {
        self.register { (textField) -> RxUITextFieldDelegateProxy in
            RxUITextFieldDelegateProxy(parentObject: textField, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: UITextField) -> (any UITextFieldDelegate)? {
        object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: (any UITextFieldDelegate)?, to object: UITextField) {
        object.delegate = delegate
    }
    
    // MARK: - Should 계열은 Proxy 내부에서 PublishSubject로 직접 방출
    let shouldReturnSubject = PublishSubject<Void>()
    let shouldEndEditingSubject = PublishSubject<Void>()
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturnSubject.onNext(())
        return (_forwardToDelegate?
            .textFieldShouldReturn?(textField)) ?? true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        shouldEndEditingSubject.onNext(())
        return (_forwardToDelegate?
            .textFieldShouldEndEditing?(textField)) ?? true
    }
}

/*
 should 계열은 반환값이 중요한데 methodInvoked는 반환값을 바꿀 수 없다
 sentMessage: delegate 실행 전
 methodInvoked: delegate 실행 후
 */
// extension Reactive로 이벤트 등록
extension Reactive where Base: UITextField {
    private var proxy: RxUITextFieldDelegateProxy {
        RxUITextFieldDelegateProxy.proxy(for: base)
    }

    var delegate: DelegateProxy<UITextField, UITextFieldDelegate> {
        proxy
    }

    // MARK: - didBeginEditing
    var didBeginEditing: Observable<Void> {
        delegate
            .methodInvoked(#selector(UITextFieldDelegate.textFieldDidBeginEditing(_:)))
            .map { _ in () }
    }

    // MARK: - didEndEditing
    var didEndEditing: Observable<Void> {
        delegate
            .methodInvoked(#selector(UITextFieldDelegate.textFieldDidEndEditing(_:)))
            .map { _ in () }
    }

    // MARK: - shouldReturn
    var shouldReturn: Observable<Void> {
        proxy.shouldReturnSubject.asObservable()
    }

    // MARK: - shouldEndEditing
    var shouldEndEditing: Observable<Void> {
        proxy.shouldEndEditingSubject.asObservable()
    }

    // MARK: - shouldClear
    var shouldClear: Observable<Void> {
        proxy
            .sentMessage(#selector(UITextFieldDelegate.textFieldShouldClear(_:)))
            .map { _ in () }
    }

    // MARK: - shouldChangeCharacters
    var shouldChangeCharacters: Observable<(range: NSRange, replacement: String)> {
        proxy
            .sentMessage(
                #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))
            )
            .map { parameters in
                let range = parameters[1] as! NSRange
                let replacement = parameters[2] as! String
                return (range, replacement)
            }
    }
}
