//
//  Constants.swift
//  RxTodo
//
//  Created by 김동현 on 5/3/26.
//

import Foundation

enum Constants {
    static let baseURL: String = {
        #if DEBUG
        return "http://127.0.0.1:8000/api"
        
        #else
        return "http://127.0.0.1:8000/api"
        
        #endif
    }()
}
