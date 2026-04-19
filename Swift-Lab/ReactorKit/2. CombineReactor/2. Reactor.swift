//
//  Reactor.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/19/26.
//

import Foundation
import Combine

protocol ReactorProtocol {
    associatedtype Action
    associatedtype Mutation
    
    func mutate(action: Action) -> Effect<Mutation>
    func reduce(mutation: Mutation)
}

class Reactor<Action, Mutation>: ReactorProtocol {
    func mutate(action: Action) -> Effect<Mutation> {
        fatalError("override me")
    }
    
    func reduce(mutation: Mutation) {
        fatalError("override me")
    }
    
    let action = PassthroughSubject<Action, Never>() /// 액션 입력 통로
    var cancellables = Set<AnyCancellable>()         /// 구독 저장 공간
    
    init() {
        /// action의 subject에서 액션이 하나가 들어올 때마다 실행된다
        /// ex) action.send(.tapRefresh)
        action.flatMap { [weak self] action -> AnyPublisher<Mutation, Never> in
            /// self가 메모리에서 해제되었다면 아무것도 방출하지 않는 빈 Publisher를 반환한다
            guard let self = self else { return Empty().eraseToAnyPublisher() }
            
            /// Action 하나를 받아서 Mutation 스트림으로 바꾼다
            return self.mutate(action: action).publisher
        }
        .sink { [weak self] mutation in
            self?.reduce(mutation: mutation)
        }
        .store(in: &cancellables)
    }
}
