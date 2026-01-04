import Foundation

/**============================================================
Swift에서 사용하는 데이터타입
- 1) Int: 정수(Integer) - 8바이트
- 2) Float: 실수(부동소수점) Floating-point Number  6자리 소수점 - 4바이트
- 3) Double: 실수(부동소수점) 15자리 소수점 - 8바이트
- 4) Character: 문자(글자 한개) - 가변
- 5) String: 문자열 - 가변
- 6) Bool: 참과 거짓 - 1바이트
- 7) 기타: UInt, UInt64, UInt32, UInt16, UInt8:  0, 그리고 양의 정수
===============================================================**/

/*
 변수를 선언하면서 저장
 - 메모리 공간을 먼저 생성하는 동시에 데이터를 저장
 */
var num: Int = 3



/*
 데이터 타입
 - 데이터를 받아 얼마 만큼의 크기, 어떤 형태로 저장할 것인지에 대한 약속
 */



/*
 Double, Float는 10진수가 아니라 2진수 비트로 근사 값을 저장하기 때문에 오차가 생실 수 있다
 */
0.1 + 0.2 == 0.3
print(0.1 + 0.2)

// 해결법
extension Double {
    func isAlmostEqual(to other: Double,
                       tolerance: Double = 1e-9) -> Bool {
        return abs(a-b) < tolerance
    }
}

let a = 0.1 + 0.2
let b = 0.3
a.isAlmostEqual(to: b)



/*
 1) 타입 주석(Type Annotation)
 - 변수를 선언하면서 타입도 명확하게 지정하는 방식
 */
var name: String    /// 1) 변수를 선언(타입 선언) - 메모리에 공간을 먼저 생성
name = "김동현"       /// 2) 값을 저장(초기화)        - 데이터를 저장



/*
 2) 타입 추론(Type Inference)
 - 타입을 지정하지 않아도 컴파일러가 타입을 유치해서 알맞는 타입으로 저장하는 방식
 */
var name2 = "김동현"
type(of: name2)



/*
 3) 타입 안전성(Type Safety)
 - 스위프트는 다른 타입끼리 계산할 수 없다
 - 어떤 변수가 정수 형태로 선언되면 그 변수는 정수만 담을 수 있다
 */
var number = 12
// number = 3.14    ❌ Cannot assign value of type 'Double' to type 'Int'



/*
 4) 타입 형 변환(Type Conversion)
 - 타입을 변형해서 사용할 수 있다
 */
let str = "1234"
let number2 = Int(str)



let str2 = "a"
let number3 = Int(str2)



/*
 5) 타입 애일리어스(Type Alias)
 - 수학의 치환과 동일한 문법
 */
typealias Name = String
var myName: Name = "김동현"

typealias Something = (Int) -> String
func someFunction(completion: (Int) -> String) {}
func someFunction2(completion: Something) {}
