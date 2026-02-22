//
//  RxImagePickerVC2.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/22/26.
//

/*
 https://rldd.tistory.com/274
 https://eunjin3786.tistory.com/28
 https://ios-development.tistory.com/152
 
 [Delegate]
 - 함수 실행위치를 미리 선언해두고 구현은 직접 하라고 delegate 시키는 것(protocol로 선언)
 
 [Delegate Proxy]
 - delegate를 사용하는 부분을 RxSwift로 표현할 수 있도록 하는 것
 - 원리: DelegateProxy.swift 파일과 DelegateProxyType.swift 이용
 
 [Reactive]
 - RxCocoa에서 모든 UIKit 객체는 아래형태로 접근 가능
 - button.rx,tap
 - label.rx.tap
 - textField.rx.text
 => 여기서 .rx란 내부적으로 아래와 같다
 
 // button.rx: Reactive<UIButton>
 extension ReactiveCompatible {
     public var rx: Reactive<Self> { ... }
 }
 
 // Reactive<UIButton> 일때만 이 확장을 적용해라
 // 이러면 button.rx일 때만 tap을 쓸 수 있음
 extension Reactive where Base: UIButton {
    // public var tap: ControlEvent<Void> = 버튼이 눌릴 때 발생하는 Observable 이벤트
    public var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
 }
 


 
 
 */
import Foundation
