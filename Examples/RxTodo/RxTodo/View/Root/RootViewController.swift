//  RootViewController.swift
//  RxTodo
//
//  Created by 김동현 on 5/4/26.
//

import ReactorKit
import RxSwift
import UIKit

final class RootViewController: UIViewController, View {
    typealias Reactor = RootReactor

    var disposeBag = DisposeBag()
    private let customView = RootView()

    // MARK: - Initializer
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = customView
    }

    func bind(reactor: Reactor) {
        Observable.just(())
            .subscribe(onNext: { _ in
                reactor.action.onNext(.viewDidLoad)
            })
            .disposed(by: disposeBag)

        reactor.state
            .observe(on: MainScheduler.instance)
            .map(\.message)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] message in
                self?.title = "Todos"
                self?.customView.updateMessage(message)
            })
            .disposed(by: disposeBag)
    }
}

#Preview {
    RootViewController(reactor: RootReactor(repository: TodoRepositoryImpl()))
}
