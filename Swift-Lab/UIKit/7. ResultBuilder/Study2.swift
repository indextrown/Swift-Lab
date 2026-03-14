//
//  Study2.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/10/26.
//

import Foundation

// 여러 표현식을 모아서 하나의 배열로 만드는 기본 함수
@resultBuilder
struct SimpleListBuilder<T> {
    // DSL 내부의 여러 줄 값을 모아서 배열 생성
    //
    // DSL 코드
    // makeList {
    //    "A"
    //    "B"
    //    "C"
    // }
    //
    // 컴파일러 내부 변환
    // buildBlock("A","B","C")
    //
    // 결과
    // ["A","B","C"]
    /*
     [DSL]
     makeList {
         "A"
         "B"
         "C"
     }
     
     [컴파일러 내부]
     SimpleListBuilder<String>.buildBlock(
         "A",
         "B",
         "C"
     )
     
     [buildBlock] 실행
     components = ["A","B","C"]
     */
    static func buildBlock(_ components: T...) -> [T] {
        return Array(components)
    }
}

func makeList<T>(@SimpleListBuilder<T> content: () -> [T]) -> [T] {
    content()
}

func simple_test1() {
    let items = makeList {
        "A"
        "B"
        "C"
    }
    print(items) // ["A","B","C"]
}

extension SimpleListBuilder {

    // if 조건문 처리
    //
    // DSL 코드
    // makeList {
    //   "A"
    //   if true {
    //      "B"
    //   }
    // }
    //
    // 내부 변환
    // buildOptional(["B"])
    //
    // if false면
    // buildOptional(nil)
    static func buildOptional(_ component: [T]?) -> [T] {
        component ?? []
    }
}

extension SimpleListBuilder {

    // if-else에서 첫 번째 분기
    //
    // DSL
    // if condition {
    //    "A"
    // } else {
    //    "B"
    // }
    //
    // condition == true
    // buildEither(first:["A"])
    static func buildEither(first component: [T]) -> [T] {
        component
    }

    // if-else에서 두 번째 분기
    //
    // condition == false
    // buildEither(second:["B"])
    static func buildEither(second component: [T]) -> [T] {
        component
    }
}
