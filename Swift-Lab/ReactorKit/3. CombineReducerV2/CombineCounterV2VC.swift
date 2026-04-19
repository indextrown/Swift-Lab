//
//  CombineCounterV2VC.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/19/26.
//

import UIKit
import Combine


final class CombineCounterV2VC: UIViewController {
    typealias Reactor = CombineCounterV2ViewReactor
    
    private let reactor: Reactor
    private var cancellables = Set<AnyCancellable>()
    
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
    
    init(reactor: Reactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Combine Counter V2"
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.addSubview(countLabel)
        view.addSubview(increaseButton)
        view.addSubview(decreaseButton)
        view.addSubview(loadingIndicator)
        
        increaseButton.addTarget(self, action: #selector(didTapIncrease), for: .touchUpInside)
        decreaseButton.addTarget(self, action: #selector(didTapDecrease), for: .touchUpInside)
        
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
    
    private func bind() {
        reactor.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.countLabel.text = String(state.value)
                if state.isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func didTapIncrease() {
        reactor.send(.increase)
    }
    
    @objc private func didTapDecrease() {
        reactor.send(.decrease)
    }
}

final class CombineCounterV2ViewReactor: ReactorV2 {
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
    
    @Pulse private(set) var state = State()
    
    func send(_ action: Action) {
        self.action.send(action)
    }
    
    override func mutate(action: Any) -> Effect<Any> {
        guard let action = action as? Action else {
            return .empty()
        }
        
        switch action {
        case .increase:
            return .concat([
                .just(Mutation.setLoading(true)),
                .from(
                    Just(Mutation.increaseValue)
                        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
                        .map { $0 as Any }
                ),
                .just(Mutation.setLoading(false))
            ])
        case .decrease:
            return .concat([
                .just(Mutation.setLoading(true)),
                .from(
                    Just(Mutation.decreaseValue)
                        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
                        .map { $0 as Any }
                ),
                .just(Mutation.setLoading(false))
            ])
        }
    }
    
    override func reduce(mutation: Any) {
        guard let mutation = mutation as? Mutation else {
            return
        }
        
        var newState = state
        
        switch mutation {
        case .increaseValue:
            newState.value += 1
        case .decreaseValue:
            newState.value -= 1
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        }
        
        state = newState
    }
}
