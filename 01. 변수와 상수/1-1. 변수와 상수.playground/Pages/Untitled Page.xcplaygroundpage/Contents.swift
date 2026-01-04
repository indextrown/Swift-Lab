import Cocoa

/*
 변수
 - 프로그램 동작의 첫 단계
 - 변수는 메모리에 값을 저장하고 이름으로 접근할 수 있는 공간이다
 - 변수의 이름을 식별자 라고 부르고 한 영역에 유일한 이름으로 사용된다
 */
var name = "김동현"
var age = 27
print(age, name)

// 변수를 여러개 선언하는 방법
var x = 1, y = 2, z = 3

// 새로운 공간을 만들고 값을 복사(Copy)해서 저장
name = "인덱스"



/*
 String Interpolation(문자열 보간법)
 - \(삽입변수) - 중간에 삽입 시 사용
 */
print("Hello, \(name)!")



/*
 상수
 - 프로그램 실행 중 처음에 저장된 값이 변하지 않도록 보장된 변수다
 */
let name2 = "김동현"
// name2 = "인덱스"                                            ❌ Cannot assign to value: 'name2' is a 'let' constant
 
