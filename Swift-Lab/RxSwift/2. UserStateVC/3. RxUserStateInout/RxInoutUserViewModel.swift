//
//  RxInoutUserViewModel.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/26/26.
//

import UIKit
import RxSwift
import RxCocoa

final class RxInoutUserViewModel {
    
    private let disposeBag = DisposeBag()
    
    enum State {
        case initial
        case loading
        case loaded(User)
        case error(String)
    }
    
    // MARK: - Input {
    struct Input {
        let tap: Observable<Void>
    }
    
    // MARK: - Output
    struct Output {
        let state: Observable<State>
    }
    
    func transform(input: Input) -> Output {
        let state = PublishRelay<State>()
        
        input.tap
            .flatMapLatest { _ -> Observable<State> in
                let success = Bool.random()
                
                // loading먼저
                let loading = Observable.just(State.loading)
                
                // 결과
                let result = Observable<State>.create { observer in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if success {
                            let user = User(
                                id: 0,
                                name: "abc",
                                userName: "abc_id",
                                phone: "010-1234-5678"
                            )
                            observer.onNext(.loaded(user))
                        } else {
                            observer.onNext(.error("에러 발생"))
                        }
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
                return loading.concat(result)
            }
            .bind(to: state)
            .disposed(by: disposeBag)
        
        return Output(state: state.asObservable())
    }
}
