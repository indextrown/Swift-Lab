import UIKit

protocol Animal {
    func eat()
}
struct Cow: Animal {
    func eat() {
        print("소가 풀을 먹는다")
    }
}
struct Chicken: Animal {
    func eat() {
        print("닭이 모이를 먹는다")
    }
}

// 제네릭 방식
//func makeAnimal<A: Animal>() -> A {
//    return Chicken() as! A
//}

/**
 some 방식
 - 특정 프로토콜을 준수하는 고정된 타입을 나타내기 위한 코드
 - Swift에서는 특정 프로토콜을 준수하는 고정된 타입을 나타내기 위해 some을 사용한다.
 - 구체 타입이 아닌 프로토콜 타입으로 설정하여 사용하는 쪽에서는 구체 타입을 알 필요가 없다.
 - 동시에 구체 타입이 컴파일 시점에 결정되므로 타입 안전성이 높다.
 
 정리:
 Swift의 Oqaque Type는 특정 프로토콜을 준수하는 고정된 단일 Underlying Type을 숨겨, 캡슐화와 컴파일러의 최적화 + 안전성을 제공한다.
 */
func makeChicken() -> some Animal {
    return Chicken()
}
