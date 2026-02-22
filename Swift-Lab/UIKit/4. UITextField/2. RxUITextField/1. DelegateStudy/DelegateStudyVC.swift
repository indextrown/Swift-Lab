//
//  DelegateStudy.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/22/26.
//

/*
 [NsObject]
 - 어플리케이션 대부분의 객체에 필요한 기본 동작을 정의하는 클래스다
 - 객체를 생성, 복사, 비교, 메모리 해제 메서드를 제공한다
 https://green1229.tistory.com/534
 https://clamp-coding.tistory.com/438
 
 */
import UIKit

protocol MyDelegate {
    func willStart()
    func willFinish()
}

class UISomething: NSObject {
    var delegate: MyDelegate? = nil
    
    func start() {
        delegate?.willStart()  // 이 함수를 델리게이트 시킨다
        print("작업 실행")
        delegate?.willFinish() // 이 함수를 델리게이트 시킨다
    }
}

class CustomDelegateVC: UIViewController {
    
    let someUI = UISomething()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        someUI.delegate = self
        someUI.start()
    }
}

extension CustomDelegateVC: MyDelegate {
    func willStart() {
        print("시작 전")
    }
    
    func willFinish() {
        print("끝")
    }
    
}

#Preview {
    CustomDelegateVC()
}
