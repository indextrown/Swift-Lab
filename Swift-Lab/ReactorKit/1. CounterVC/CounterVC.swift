//
//  CounterVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/13/26.
//

import UIKit
import ReactorKit

//import UIKit
//import RxSwift
//import RxCocoa
//import ReactorKit

final class CounterVC: UIViewController, ReactorKit.View {
    typealias Reactor = CounterViewReactor
    
    var disposeBag = DisposeBag()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .black
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("증가", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("감소", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(reactor: CounterViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Counter"
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(countLabel)
        view.addSubview(increaseButton)
        view.addSubview(decreaseButton)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            
            increaseButton.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 32),
            increaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
            
            decreaseButton.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 32),
            decreaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            
            loadingIndicator.topAnchor.constraint(equalTo: increaseButton.bottomAnchor, constant: 24),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func bind(reactor: CounterViewReactor) {
        increaseButton.rx.tap
            .map { CounterViewReactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        decreaseButton.rx.tap
            .map { CounterViewReactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { String($0.value) }
            .distinctUntilChanged()
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isLoading in
                isLoading
                ? self?.loadingIndicator.startAnimating()
                : self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}


import ReactorKit

final class CounterViewReactor: Reactor {
    let initialState = State()
    
    enum Action {
        case increase
        case decrease
    }
    
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
    }
    
    struct State {
        var value: Int = 0
        var isLoading: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return .concat([
                .just(.setLoading(true)),
                .just(.increaseValue)
                .delay(.seconds(1), scheduler: MainScheduler.instance),
                .just(.setLoading(false))
            ])
        case .decrease:
            return .concat([
                .just(.setLoading(true)),
                .just(.decreaseValue)
                .delay(.seconds(1), scheduler: MainScheduler.instance),
                .just(.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .increaseValue:
            newState.value += 1
        case .decreaseValue:
            newState.value -= 1
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}
