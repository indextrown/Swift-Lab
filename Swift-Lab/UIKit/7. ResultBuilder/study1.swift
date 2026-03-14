//
//  study1.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/10/26.
//
// https://green1229.tistory.com/585

import Foundation

// 기존 방식
func test1() {
    var items: [String] = []
    items.append("첫번째")
    if true {
        items.append("조건부")
    }
    items.append("마지막")
}


@resultBuilder
struct ArrayBuilder<Element> {
    // 0. 단일 표현식 처리
    static func buildBlock(_ components: Element...) -> [Element] {
        Array(components)
    }
    
    // 1. 여러 줄 결과를 하나로 합치는 함수
    //
    // DSL 코드
    // "첫번째"
    // "마지막"
    //
    // 컴파일러 내부 변환
    // buildBlock(
    //   buildExpression("첫번째"),
    //   buildExpression("마지막")
    // )
    //
    // 실제 전달 값
    // [["첫번째"], ["마지막"]]
    //
    // flatMap으로
    // ["첫번째","마지막"] 생성
    static func buildBlock(_ components: [Element]...) -> [Element] {
        components.flatMap { $0 }
    }
    
    // 2. 조건부 처리(if)
    // if 문 (else 없음)
    //
    // DSL
    // if true {
    //   "조건부"
    // }
    //
    // 내부
    // buildOptional(["조건부"])
    //
    // if false일 경우
    // buildOptional(nil)
    static func buildOptional(_ component: [Element]?) -> [Element] {
        component ?? []
    }
    
    // 3. 분기 처리(if-else)
    // if - else 분기 처리
    //
    // DSL
    // if flag {
    //   "A"
    // } else {
    //   "B"
    // }
    //
    // 내부 변환
    // buildEither(first:["A"])
    // 또는
    // buildEither(second:["B"])
    static func buildEither(first component: [Element]) -> [Element] {
        component
    }
    
    static func buildEither(second component: [Element]) -> [Element] {
        component
    }
    
    // 4. 배열 평탄화
    // for loop 처리
    //
    // DSL
    // for i in 1...3 {
    //   "item \(i)"
    // }
    //
    // 내부 전달 값
    // [
    //   ["item 1"],
    //   ["item 2"],
    //   ["item 3"]
    // ]
    //
    // flatMap으로
    // ["item 1","item 2","item 3"]
    static func buildArray(_ components: [[Element]]) -> [Element] {
        components.flatMap { $0 }
    }
    
    // 5. 단일 표현식을 배열로 변환
    // 일반 표현식 한 줄 처리
    //
    // DSL
    // "첫번째"
    //
    // 내부 변환
    // buildExpression("첫번째")
    //
    // 결과
    // ["첫번째"]
    static func buildExpression(_ expression: Element) -> [Element] {
        [expression]
    }
}

/*
 buildBlock(
    buildExpression("첫번째"),
    buildOptional(
         buildExpression("조건부")
    ),
    buildExpression("마지막")
 )
 ==> ["첫번째", "조건부", "마지막"]
 */
@ArrayBuilder<String>
func makeItems() -> [String] {
    
    // buildExpression("첫번째")
    "첫번째"
    
    // buildOptional
    if true {
        // buildExpression("조건부")
        "조건부"
    }
    // buildExpression("마지막")
    "마지막"
}

/*
 public init(
     @ViewBuilder content: () -> Content
 )
 
 VStack {
     Text("첫번째")
     Text("두번째")
 }
 
 VStack(
     content: {
         Text("첫번째")
         Text("두번째")
     }
 )
 
 ViewBuilder.buildBlock(
     ViewBuilder.buildExpression(Text("첫번째")),
     ViewBuilder.buildExpression(Text("두번째"))
 )
 */
