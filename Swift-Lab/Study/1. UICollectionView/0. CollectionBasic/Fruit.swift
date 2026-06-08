//
//  Fruit.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/19/26.
//

import UIKit

/// 컬렉션 뷰에 표시할 단순 데이터 모델입니다.
struct Fruit {
    let id = UUID()
    let name: String
    let color: UIColor
}
