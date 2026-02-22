//
//  MenuItem.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/19/26.
//

import UIKit

// 각 셀에 표시할 메뉴 정보
struct MenuItem: Hashable {
    let id = UUID()
    let title: String
    let viewControllerType: UIViewController.Type
    
    // 해시값 만드는 기준
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // 두 MenuItem이 같다고 판단하는 기준
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        lhs.id == rhs.id
    }
}

// 섹션
enum MenuSection: String, CaseIterable {
    case uitableview = "테이블뷰"
    case imagePicker = "이미지 피커"
    case textField = "텍스트필드"
}

let menuData: [MenuSection: [MenuItem]] = [
    .uitableview: [
        MenuItem(title: "테이블뷰", viewControllerType: UITableVC.self),
        MenuItem(title: "테이블뷰2", viewControllerType: UITableVC2.self)
    ],
    
    .imagePicker: [
        MenuItem(title: "이미지 피커", viewControllerType: ImagePickerVC.self),
        MenuItem(title: "Rx 이미지 피커", viewControllerType: RxImagePickerVC.self)
    ],
    
    .textField: [
        MenuItem(title: "텍스트필드", viewControllerType: TextFieldVC.self),
        MenuItem(title: "Rx텍스트필드", viewControllerType: RxTextFieldVC.self),
        MenuItem(title: "Delegate 커스텀", viewControllerType: CustomDelegateVC.self)
    ]
]
