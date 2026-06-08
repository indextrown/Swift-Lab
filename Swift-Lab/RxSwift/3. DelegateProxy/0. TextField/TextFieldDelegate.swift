//
//  TextFieldDelegate.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/21/26.
//
/**
 [텍스트필드 기본 사용법]ˇ
 - https://xerathcoder.tistory.com/234
 - https://ios-daniel-yang.tistory.com/entry/UITextField
 
 [Delegate Proxy]
 - https://ios-development.tistory.com/152

 //TextField의 편집을 시작할 수 있게 할지 말지 결정하는 함수
 func textFieldShouldBeginEditing(UITextField) -> Bool

 //TextField의 편집이 시작되고 나서 실행되는 함수(즉, 커서가 깜빡이는 순간 실행됨)
 func textFieldDidBeginEditing(UITextField)

 //TextField의 편집을 중지할 수 있게 할지 말지 결정하는 함수
 func textFieldShouldEndEditing(UITextField) -> Bool

 //TextField의 편집이 끝나는 순간 실행되는 함수(편집이 중지된 시점과 그 이유를 delegate에게 알림)
 func textFieldDidEndEditing(UITextField, reason: UITextField.DidEndEditingReason)

 //TextField의 편집이 끝나는 순간 실행되는 함수(delegate에게 알림)
 func textFieldDidEndEditing(UITextField)

 //TextField의 한글자씩 입력할 때마다 실행되는 함수로 변경여부도 결정하는 함수
 func textField(UITextField, shouldChangeCharactersIn: NSRange, replacementString: String) -> Bool

 //TextField의 현재 내용을 clear가 가능힌지 여부를 결정하는 함수
 func textFieldShouldClear(UITextField) -> Bool

 //TextField에 대한 return 버튼의 동작을 실행할지 말지 결정하는 함수
 func textFieldShouldReturn(UITextField) -> Bool

 //TextField의 값이 변경될 시 delegate에게 알리는 함수
 func textFieldDidChangeSelection(UITextField)

 //TextField에서 편집을 종료하는 이유를 나타내는 상수
 enum UITextField.DidEndEditingReason
 */

import UIKit

final class TextFieldDelegateVC: UIViewController {
    
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

extension TextFieldDelegateVC: UITextFieldDelegate {
    // 사용자가 텍스트 필드를 터치해서 입력하려고 할 때(키보드 올라옴 유무)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // 텍스트 필드 엔터키가 눌러지면 다음 동작 허락(키보드 내리기)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 내리기
        return true
    }
}
