//
//  TodoRepository.swift
//  RxTodo
//
//  Created by 김동현 on 5/4/26.
//

import Foundation

protocol TodoRepositoryProtocol {
    /// Escaping 클로저 방식으로 Todo 리스트를 가져옵니다.
    /// - Parameter completion: 결과를 처리할 클로저 (Result<[TodoDTO], Error>)
    func fetchTodos(completion: @escaping (Result<[TodoDTO], Error>) -> Void)
}

final class TodoRepositoryImpl: TodoRepositoryProtocol {

    /// Escaping 클로저 방식으로 Todo 리스트를 가져옵니다.
    /// - Parameter completion: 결과를 처리할 클로저
    func fetchTodos(completion: @escaping (Result<[TodoDTO], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/todos") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        NetworkManager.shared.fetch(with: url, type: [TodoDTO].self) { result in
            completion(result)
        }
    }
}
