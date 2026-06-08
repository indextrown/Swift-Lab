//  RootReactor.swift
//  RxTodo
//
//  Created by 김동현 on 5/4/26.
//

import Foundation
import ReactorKit
import RxSwift

final class RootReactor: Reactor {
    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case setTodos([TodoDTO])
        case setError(String)
    }

    struct State {
        var message = "Loading todos..."
    }

    let initialState = State()

    private let repository: TodoRepositoryProtocol

    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.create { [repository] observer in
                repository.fetchTodos { result in
                    switch result {
                    case .success(let todos):
                        observer.onNext(.setTodos(todos))
                    case .failure(let error):
                        observer.onNext(.setError(Self.errorMessage(from: error)))
                    }
                    observer.onCompleted()
                }

                return Disposables.create()
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setTodos(let todos):
            newState.message = "Loaded \(todos.count) todos"
        case .setError(let message):
            newState.message = message
        }

        return newState
    }

    private static func errorMessage(from error: Error) -> String {
        if let decodingError = error as? DecodingError {
            return "Decoding failed: \(decodingError)"
        }

        return error.localizedDescription
    }
}
