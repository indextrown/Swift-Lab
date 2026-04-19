//
//  Pulse.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/19/26.
//
// https://matdongsane.tistory.com/209
// https://green1229.tistory.com/322

import Foundation
import Combine

/// @Pulse var count: Int = 0처럼 타입을 프로퍼티 앞에 붙여서 쓸 수 있다
/// Pulse<Int>가 들어가서 동작한다
/// 제네릭으로 만들어져 있어서 어떤 타입이든 감쌀 수 있다
@propertyWrapper
final class Pulse<Value> {
    /// 현재 값을 하나 들고 있다
    /// 값이 바뀌면 구독자에게 새 값을 보낸다
    /// 새로 구독해도 최신 값을 바로 받을 수 있다.
    private let subject: CurrentValueSubject<Value, Never>
    
    var wrappedValue: Value {
        get { subject.value }           // 읽을 때 subject.value 꺼내기
        set { subject.send(newValue) }  // 쓸때 값변경 + 구독 중인 곳에도 새 값을 전달
    }
    
    /// wrappedValue: 실제 값
    /// wrappedValue: $변수명 으로 접근하는 추가 기능
    /// viewModel.count: 현재 값
    /// viewModel.$count: Publisher
    var projectedValue: AnyPublisher<Value, Never> {
        subject.eraseToAnyPublisher() /// 바깥에서 send()못하게 하려는 의도
    }
    
    /// 프로퍼티 래퍼를 쓸 때 초기값을 받을 수 있게 하는 생성자
    /// @Pulse var name: String = "동현"
    /// ==> let subject = CurrentValueSubject<String, Never>("동현")
    init(wrappedValue: Value) {
        self.subject = CurrentValueSubject(wrappedValue)
    }
}
