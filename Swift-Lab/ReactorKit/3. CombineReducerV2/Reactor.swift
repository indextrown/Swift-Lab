//
//  Reactor.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/19/26.
//

import Foundation
import Combine

/// 비제네릭 Reactor 버전.
/// 내부는 Any로 타입 소거를 하고, 각 Reactor가 typed send 메서드를 따로 제공한다.
class ReactorV2 {
    let action = PassthroughSubject<Any, Never>()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        action
            .flatMap { [weak self] action -> AnyPublisher<Any, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                return self.mutate(action: action).publisher
            }
            .sink { [weak self] mutation in
                self?.reduce(mutation: mutation)
            }
            .store(in: &cancellables)
    }
    
    func mutate(action: Any) -> Effect<Any> {
        fatalError("override me")
    }
    
    func reduce(mutation: Any) {
        fatalError("override me")
    }
}
