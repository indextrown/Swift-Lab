//
//  UserStateVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/26/26.
//
/*
 https://steelbeartaeng2.tistory.com/152
 */

import UIKit

final class UserStateVC: UIViewController {
    private let viewModel = UserViewModel()
    private let label = UILabel()
    private let button = UIButton(type: .system)
    private let loading = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .white

        label.numberOfLines = 0
        label.textAlignment = .center

        button.setTitle("사용자 조회", for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)

        loading.hidesWhenStopped = true

        let stack = UIStackView(arrangedSubviews: [label, loading, button])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func bind() {
        viewModel.onStateChanged = { [weak self] state in
            self?.render(state)
        }
    }
    
    private func render(_ state: UserViewModel.State) {
        switch state {
        case .initial:
            label.text = "버튼 눌러"
            loading.stopAnimating()

        case .loading:
            label.text = "로딩중..."
            loading.startAnimating()
            
        case .loaded(let user):
            loading.stopAnimating()
            label.text = """
            이름: \(user.name)
            아이디: \(user.userName)
            번호: \(user.phone)
            """

        case .error(let msg):
            loading.stopAnimating()
            label.text = msg
        }
    }
    
    @objc private func didTap() {
        viewModel.fetchUser()
    }
}

struct User: Decodable {
    let id: Int
    let name: String
    let userName: String
    let phone: String
}

final class UserViewModel {
    enum State {
        case initial
        case loading
        case loaded(User)
        case error(String)
    }
    var onStateChanged: ((State) -> Void)?
    var state: State = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    func fetchUser() {
        state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let success = Bool.random()
            
            if success {
                let user = User(
                    id: 0,
                    name: "abc",
                    userName: "abc id",
                    phone: "010-1234-5678"
                )
                self.state = .loaded(user)
            } else {
                self.state = .error("에러 발생")
            }
        }
    }
}
