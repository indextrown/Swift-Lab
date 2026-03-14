//
//  test.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/6/26.
//

import Foundation

class Human {
    
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

extension Human: Equatable {
    // Equtale 해결
    static func == (lhs: Human, rhs: Human) -> Bool {
        return lhs.name == rhs.name && lhs.age == rhs.age
    }
}

extension Human: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(age)
    }
}



func main() {
    // Type 'Human' does not conform to protocol 'Hashable'
    let testDict: [Human: Int] = [:]
    
    // 예시
    let nums = [1, 2, 3]
    let strs = ["a", "b", "c"]

}

func swapTwoInt(_ a: inout Int, _ b: inout  Int) {
    let tempA = a
    a = b
    b = tempA
}

func isSameValues<T: Equatable>(_ a: T, _ b: T) -> Bool {
    return a == b
}

extension Array where Element: FixedWidthInteger {
    mutating func pop() -> Element { return self.removeLast() }
}


protocol Stack {
    associatedtype value: Equatable
//    func push(value: value)
//    func pop() -> value
    func push<T: Equatable>(value: T)
    func pop<T: Equatable>() -> T
}

//struct Test: Stack {
//    typealias value = Int
//    
//    func push(value: Int) {
//        <#code#>
//    }
//    
//    func pop() -> Int {
//        <#code#>
//    }
//}
