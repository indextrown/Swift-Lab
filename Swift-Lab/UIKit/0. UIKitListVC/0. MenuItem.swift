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
}

let menuData: [MenuSection: [MenuItem]] = [
    MenuSection.uitableview: [
        MenuItem(title: "테이블뷰", viewControllerType: UITableVC.self)
    ]
]
