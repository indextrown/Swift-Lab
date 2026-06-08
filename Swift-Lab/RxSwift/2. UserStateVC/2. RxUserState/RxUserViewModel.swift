//
//  RxUserViewModel.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/26/26.
//

import UIKit
import RxSwift
import RxCocoa

final class RxUserViewModel {
    enum State {
        case initial
        case loading
        case loaded(User)
        case error(String)
    }
    
    let state = BehaviorRelay<State>(value: .initial)
    private let disposeBag = DisposeBag()
    
    func fetchUser() {
        state.accept(.loading)
        let success = Bool.random()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if success {
                let user = User(
                    id: 0,
                    name: "abc",
                    userName: "abc_id",
                    phone: "010-1234-5678"
                )
                self.state.accept(.loaded(user))
            } else {
                self.state.accept(.error("에러 발생"))
            }
        }
    }
}
