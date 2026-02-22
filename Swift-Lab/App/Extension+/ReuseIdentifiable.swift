//
//  ReuseIdentifiable.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/20/26.
//

import UIKit

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UITableViewCell: ReuseIdentifiable {}
