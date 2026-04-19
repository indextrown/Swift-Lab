//
//  RxInoutUserVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/26/26.
//

import UIKit
import RxSwift
import RxCocoa

final class RxInoutUserVC: UIViewController {
    private let viewModel = RxInoutUserViewModel()
    private let dispistBag = DisposeBag()
    
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
        // input
        let input = RxInoutUserViewModel.Input(
            tap: button.rx.tap.asObservable()
        )
        
        // transform
        let output = viewModel.transform(input: input)
        
        // output
        output.state
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.render(state)
            })
            .disposed(by: dispistBag)
    }
    
    
    // MARK: - Render
    private func render(_ state: RxInoutUserViewModel.State) {
        switch state {

        case .initial:
            label.text = "버튼 눌러주세요"
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
}

