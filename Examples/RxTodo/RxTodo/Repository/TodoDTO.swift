//
//  TodoDTO.swift
//  RxTodo
//
//  Created by 김동현 on 5/4/26.
//

import Foundation

struct TodoDTO: Decodable {
    let id: Int
    let title: String
    let description: String
    let isDone: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case isDone = "is_done"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

