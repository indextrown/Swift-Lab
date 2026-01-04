import Cocoa

/*
 연산자(Operator)
 - 연산자는 수학적인 기호다
 - 숫자나 변수는 피연산자(Operand)라고 한다
 - 피연산자 개수에 따라 구분할 수 있다(단항, 이항, 삼항연산자)
 - 같은 타입의 데이터끼리만 연산 및 저장이 가능하다
 */

/*
 기본 연산자 종류
 
 1) 할당 연산자(Assignment Operator) =
 - 오른쪽 겂을 왼쪽에 대입한다
 */
let num = 10

/*
 2) 산술 연산자(Arithmetic Operator) +, -, *, /, %
 - 사칙 연산과 같은 기본 내장 기능
 */
Double(4/5) != Double(4) / Double(5)

/*
 추가: 모듈러 연산자
 */
let movieTime = 340
let hour = 340 / 60
let minute = 340 % 60

/*
 3) 복합 할당 연산자(Compound Assignment Operators)
 */
var value = 0
value += 2
value -= 1
value *= 5
value /= 2
value %= 2
/// value++은 지원하지 않음

/*
 4) 비교 연산자(Comparison Operators)
 - 참 거짓으로 도출
 */
let a = 10, b = 20
a == b
a != b
a > b
a >= b
a < b
a <= b

/*
 5) 논리 연산자(Logical Operators)
 - !
 - &&
 - ||
 */
!true
!false

true && true
true && false

true || true
true || false

/*
 7) 접근 연산자 .
 - 하위 개념으로 접근한다
 */
Int.random(in: 1...3)
var name = "김동현"
name.count
