//
//  Effect.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/19/26.
//

import Foundation
import Combine


/// Mutation 값을 방출하는 Combine Publisher를 감싼 타입
/// Just<Mutation> ==> AnyPublisher<Mutation, Never>
/// Publisher종류에 따라 타입이 다르다. Effect 내부에서 하나의 타입만 들고 있어야 편하니 AnyPublisher로 감싼다
struct Effect<Mutation> {
    
    /// Mutation을 내보내는 Publisher.
    /// <Output, Failure> 에서 Failure를 Never로 사용해서 에러를 내보내지 않는다
    let publisher: AnyPublisher<Mutation, Never>
}

extension Effect {
    
    // 단일 Mutation을 바로 Effect로
    static func just(_ mutation: Mutation) -> Effect {
       
        return Effect(publisher: Just(mutation).eraseToAnyPublisher())
    }
    
    // 외부 Publisher를 Effect로 감싸기
    static func from(_ pub: some Publisher<Mutation, Never>) -> Effect {
        return Effect(publisher: pub.eraseToAnyPublisher())
    }
    
    // 아무 값도 방출하지 않는 Effect
    static func empty() -> Effect {
        return Effect(publisher: Empty().eraseToAnyPublisher())
    }
    
    // 여러 Effect를 순차적으로 이어붙이기
    static func concat(_ effects: [Effect]) -> Effect {
        let combined = effects.map(\.publisher)
            // acc: 누적값
            // next: 다음값
            .reduce(Empty().eraseToAnyPublisher()) { acc, next in
                acc.append(next).eraseToAnyPublisher()
            }
        return Effect(publisher: combined)
    }
    
    // 여러 Effect를 병렬로 실행해서 merge
    static func memrge(_ effects: [Effect]) -> Effect {
        // MergeMany: 여러 Publisher를 동시에 구독하고 값이 오면 그대로 바로 흘려보낸다
        return Effect(publisher: Publishers.MergeMany(effects.map(\.publisher)).eraseToAnyPublisher())
    }
}
