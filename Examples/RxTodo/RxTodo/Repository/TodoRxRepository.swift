//
//  TodoRxRepository.swift
//  RxTodo
//
//  Created by 김동현 on 5/4/26.
//

import Foundation
import RxSwift

protocol TodoRxRepositoryProtocol {
    /// RxSwift Single 방식으로 Todo 리스트를 가져옵니다.
    /// - Returns: Todo 리스트 또는 Error를 방출하는 Single
    func fetchTodos() -> Single<[TodoDTO]>
}

final class TodoRxRepositoryImpl: TodoRxRepositoryProtocol {
    /// RxSwift Single 방식으로 Todo 리스트를 가져옵니다.
    /// - Returns: Todo 리스트 또는 Error를 방출하는 Single
    func fetchTodos() -> Single<[TodoDTO]> {
        guard let url = URL(string: "\(Constants.baseURL)/todos") else {
            return .error(URLError(.badURL))
        }

        return NetworkManager.shared.fetchObservable(from: url, type: [TodoDTO].self)
            .asSingle()
    }
}
