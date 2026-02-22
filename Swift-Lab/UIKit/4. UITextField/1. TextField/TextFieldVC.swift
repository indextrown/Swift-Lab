//
//  TextFieldVC.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/22/26.
//

/*
 https://kyxxgsoo.tistory.com/entry/코드베이스로-UITextField-작성하기
 https://hyeon-dev.tistory.com/entry/iOSUITextField-Delegate-텍스트필드-구현-글자수-제한하기
 https://ios-development.tistory.com/1562
 https://yurim-dev.tistory.com/101
 
 https://dealicious-inc.github.io/2021/12/06/rxswift-textfield.html
 https://ios-development.tistory.com/364
 https://daheenallwhite.github.io/ios/2019/07/24/Target-Action/
 */
import UIKit

final class TextFieldVC: UIViewController {
    
    private lazy var uiTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "글자를 입력하세요."
        textField.backgroundColor = .lightGray
        textField.textColor = .black
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(uiTextField)
        NSLayoutConstraint.activate([
            uiTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension TextFieldVC: UITextFieldDelegate {
    // 사용자가 텍스트 필드를 터치해서 입력하려고 할 때(키보드 올라옴 유무)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // 입력이 실제로 시작된 후 동작 처리(테두리 색 바꾸기, 안내 메시지 숨기기 등)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("유저가 텍스트 필드의 입력을 시작했다.")
    }
    
    // 텍스트 필드 글자 내용이 (한글자씩) 입력되거나 지워질 때 호출(글자 수 제한)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    // 텍스트 필드 엔터키가 눌러지면 다음 동작 허락(키보드 내리기)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 내리기
        return true
    }
    
    // 텍스트 필드의 입력이 끝날 때 호출 (끝날지 말지를 허락) (텍스트 비어있거나 형식이 틀리면 키보드 못내리기 ...)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // 입력이 완전히 끝난 후
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("유저가 텍스트 필드의 입력을 끝냈다.")
    }
    
    // 텍스트 필드 오른쪽의 ❌(clear 버튼) 눌렀을 때
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

#Preview {
    TextFieldVC()
}

