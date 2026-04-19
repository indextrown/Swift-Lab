//
//  UIKitAnumation.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/15/26.
//

import UIKit

struct UIKitAccount {
    let bank: String
    let balance: String
    let color: UIColor
}


final class UIKitTossRowButton: UIControl {
    
    private let iconView = UIView()
    private let titleLabelView = UILabel()
    private let balanceLabel = UILabel()
    private let sendButton = UIButton(type: .system)
    
    private let stack = UIStackView()
    private let textStack = UIStackView()
    
    
    init(account: UIKitAccount) {
        super.init(frame: .zero)
        setupUI(account: account)
        setupInteraction()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI(account: UIKitAccount) {
        
        layer.cornerRadius = 16
        
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
        
        // icon
        iconView.backgroundColor = account.color
        iconView.layer.cornerRadius = 22
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // text stack
        textStack.axis = .vertical
        textStack.spacing = 2
        
        titleLabelView.text = account.bank
        titleLabelView.font = .preferredFont(forTextStyle: .caption1)
        
        balanceLabel.text = account.balance
        balanceLabel.font = .preferredFont(forTextStyle: .headline)
        
        textStack.addArrangedSubview(titleLabelView)
        textStack.addArrangedSubview(balanceLabel)
        
        // send button
        var config = UIButton.Configuration.plain()

        config.title = "송금"
        config.baseForegroundColor = .label
        config.background.backgroundColor = UIColor.gray.withAlphaComponent(0.2)

        config.background.cornerRadius = 10

        config.contentInsets = NSDirectionalEdgeInsets(
            top: 6,
            leading: 12,
            bottom: 6,
            trailing: 12
        )

        sendButton.configuration = config
        sendButton.titleLabel?.font = .systemFont(ofSize: 13)


        
        // spacer
        let spacer = UIView()
        
        iconView.isUserInteractionEnabled = false
        titleLabelView.isUserInteractionEnabled = false
        balanceLabel.isUserInteractionEnabled = false
        sendButton.isUserInteractionEnabled = false
        textStack.isUserInteractionEnabled = false
        stack.isUserInteractionEnabled = false
        
        stack.addArrangedSubview(iconView)
        stack.addArrangedSubview(textStack)
        stack.addArrangedSubview(spacer)
        stack.addArrangedSubview(sendButton)
    }

    


}

private extension UIKitTossRowButton {

    func setupInteraction() {
        
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }
    
    @objc func touchDown() {
//        UIView.animate(
//            withDuration: 0.12,
//            delay: 0,
//            options: [.allowUserInteraction, .curveEaseOut]
//        )

        
        UIView.animate(withDuration: 0.12) {
            self.backgroundColor = UIColor.gray.withAlphaComponent(0.15)
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }

    }
    
    @objc func touchUp() {
        
        UIView.animate(withDuration: 0.12) {
            self.backgroundColor = .clear
            self.transform = .identity
        }
        
        sendActions(for: .primaryActionTriggered)
    }
}

final class AnimationVC: UIViewController {
    
    let accounts: [UIKitAccount] = [
        UIKitAccount(bank: "IBK기업은행 계좌", balance: "?원", color: .systemBlue),
        UIKitAccount(bank: "내 모든 계좌", balance: "잔액 보기", color: .systemOrange),
        UIKitAccount(bank: "투자 · 토스증권", balance: "잔액 보기", color: .systemBlue)
    ]

    private let stack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        accounts.forEach { account in
            
            let row = UIKitTossRowButton(account: account)
            
            row.heightAnchor.constraint(equalToConstant: 76).isActive = true

            
            row.addTarget(self, action: #selector(tapRow(_:)), for: .primaryActionTriggered)
            
            stack.addArrangedSubview(row)
        }
    }
    
    @objc private func tapRow(_ sender: UIKitTossRowButton) {
        print("row tapped")
    }
}

#Preview {
    AnimationVC()
}

