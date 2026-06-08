import UIKit

/**
 any를 쓰면 구체 타입은 숨겨지고, “이 프로토콜을 따른다”는 사실만 남는다
 let p = printers[0] -> 여기서 p의 타입은 any Printer 타입이라 컴파일러는 Printer를 따르는건 알지만 Value가 Int인지 String인지 모른다
 
 
 protocol Printer {
     associatedtype Value
     func printValue(_ value: Value)
 }

 struct IntPrinter: Printer {
     func printValue(_ value: Int) {
         print("Int: \(value)")
     }
 }

 struct StringPrinter: Printer {
     func printValue(_ value: String) {
         print("String: \(value)")
     }
 }
 
 let printers: [any Printer] = [
     IntPrinter(),
     StringPrinter()
 ]
 let p = printers[0]
 p.printValue(1) // 에러
 */







protocol Printer {
    associatedtype Value
    func printValue(_ value: Value) // Printer인건 알겠는데 Value가 Int인지 String인지 모름
}

struct IntPrinter: Printer {
    func printValue(_ value: Int) { // Value == Int
        print("Int: \(value)")
    }
}

struct StringPrinter: Printer {
    func printValue(_ value: String) { // Value == String
        print("String: \(value)")
    }
}

/// IntPrinter든 StringPrinter든 printValue()를 공통 방식으로 다루기 위해 파라미터를 Any로 지정
private protocol PrinterBox {
    func printValue(value: Any)
}

/// 이 박스가 생성될 때 구체 타입이 확정된다
/// AnyPrinter(IntPrinter()).      --> Base == IntPrinter, Base.Value == Int
/// AnyPrinter(StringPrinter()) --> Base == StringPrinter, Base.Value == String
private struct AnyPrinterBox<Base: Printer>: PrinterBox {
    let base: Base
    
    /// Base.Value가 뭔지 박스는 알고 있어서 이렇게 가능
    /**
     내부적으로 풀어쓴다면 아래 두 메서드, 또는 새로운 프린터가 추가되어 늘어날 로직을 하나로 해결 가능해진다
     [IntPrinter]
     func printValue(value: Any) {
         guard let value = value as? Int else { return }
         base.printValue(value)
     }

     [StringPrinter]
     func printValue(value: Any) {
         guard let value = value as? String else { return }
         base.printValue(value)
     }
     */
    func printValue(value: Any) {
        guard let value = value as? Base.Value else { return }
        base.printValue(value)
    }
}

struct AnyPrinter {
    private let box: any PrinterBox
    
    init(_ base: some Printer) {
        self.box = AnyPrinterBox(base: base)
    }
    
    func printValue(_ value: Any) {
        box.printValue(value: value)
    }
}

let printers: [AnyPrinter] = [
    AnyPrinter(IntPrinter()),
    AnyPrinter(StringPrinter())
]

printers[0].printValue(1)
printers[1].printValue("hello")


/**
 1. printers[0]은 AnyPrinter
 2. 내부 box는 사실 AnyPrinterBox<IntPrinter>
 3. AnyPrinter.printValue(1) 호출
 4. 내부에서 box.printValue(value: 1) 호출
 5. 실제로는 AnyPrinterBox<IntPrinter>.printValue(value: 1) 실행
 6. 1 as? Base.Value 검사
 7. 여기서 Base.Value == Int 이므로 성공
 8. base.printValue(1) 호출
 9. 최종적으로 IntPrinter.printValue(1) 실행
 */


/**
 AnyPrinter(IntPrinter())를 만들 때 내부적으로 AnyPrinterBox<IntPrinter>가 생성됨
 AnyPrinter(StringPrinter())를 만들 때 내부적으로 AnyPrinterBox<StringPrinter>가 생성됨
 
 -> 겉으로는 둘 다 AnyPrinter처럼 보임
 -> 하지만 내부 box는 자기 Base 타입을 알고 있어서 호출 시점에
        - IntPrinter 박스는 Base.Value == Int
        - StringPrinter 박스는 Base.Value == String
        즉 내부에서 캐스팅 후 원래 메서드를 호출할 수 있음
        Box는 숨겨진 구체 타입을 내부에서 계속 기억하는 장치
 */



//struct AnyPrinter {
//    private let _printValue: (Any) -> Void
//
//    init<P: Printer>(_ base: P) {
//        self._printValue = { value in
//            guard let value = value as? P.Value else { return }
//            base.printValue(value)
//        }
//    }
//
//    func printValue(_ value: Any) {
//        _printValue(value)
//    }
//}




/*
protocol Printer {
    associatedtype Value
    func printValue(_ value: Value)
}

struct IntPrinter: Printer {
    func printValue(_ value: Int) {
        print("Int: \(value)")
    }
}

struct StringPrinter: Printer {
    func printValue(_ value: String) {
        print("String: \(value)")
    }
}

struct AnyPrinter {
    private let _printValue: (Any) -> Void

    init<P: Printer>(_ base: P) {
        self._printValue = { value in
            guard let value = value as? P.Value else { return }
            base.printValue(value)
        }
    }

    func printValue(_ value: Any) {
        _printValue(value)
    }
}

let printers: [AnyPrinter] = [
    AnyPrinter(IntPrinter()),
    AnyPrinter(StringPrinter())
]

printers[0].printValue(1)
printers[1].printValue("hello")
*/
