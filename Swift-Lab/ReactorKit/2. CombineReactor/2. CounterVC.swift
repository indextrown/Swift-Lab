//
//  CounterVC.swift
//  Swift-Lab
//
//  Created by GitHub Copilot on 4/19/26.
//

import UIKit
import Combine

final class CombineCounterVC: UIViewController {
    typealias Reactor = CombineCounterViewReactor

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
        title = "Combine Counter"
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
        reactor.action.send(.increase)
    }

    @objc private func didTapDecrease() {
        reactor.action.send(.decrease)
    }
}

final class CombineCounterViewReactor: Reactor<CombineCounterViewReactor.Action, CombineCounterViewReactor.Mutation> {
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

    override func mutate(action: Action) -> Effect<Mutation> {
        switch action {
        case .increase:
            return .concat([
                .just(.setLoading(true)),
                .from(Just(.increaseValue)
                    .delay(for: .seconds(1), scheduler: DispatchQueue.main)),
                .just(.setLoading(false))
            ])
        case .decrease:
            return .concat([
                .just(.setLoading(true)),
                .from(Just(.decreaseValue)
                    .delay(for: .seconds(1), scheduler: DispatchQueue.main)),
                .just(.setLoading(false))
            ])
        }
    }

    override func reduce(mutation: Mutation) {
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
