import Cocoa

/*
 if
 - 참과 거짓을 판별할 수 있는 문장을 만족하면 중괄호 내부를 실행한다
 - if 다음에는 조건을 쓴다
 - 조건의 자리에는 결과가 참 또는 거짓이 나와야 한다
 - 범위가 작은 조건문이 먼저 와야한다
 */
let 참과_거짓을_판별할_수_있는_문장 = true
if 참과_거짓을_판별할_수_있는_문장 {
    
}

/*
 1) 논리적인 오류 없도록 조건의 순서가 중요
 */
let num = 8

// 질못된 예시
if num >= 0 {
    print("0 또는 양수입니다")
} else if num % 2 == 0 {
    print("짝수 입니다")
} else if num % 2 == 0 {
    print("홀수입니다")
} else {
    print("음수입니다")
}

// 올바른 예시
if num >= 0 {
    print("0 또는 양수입니다")
    if num % 2 == 0 {
        print("짝수 입니다")
    } else if num % 2 == 0 {
        print("홀수입니다")
    }
} else {
    print("음수입니다")
}

/*
 2) 조건의 확인 순서를 잘 고려해야 한다
 */
var score = 100

// 잘못된 예시
if score >= 70 {
    print("70점 이상입니다.")
} else if score >= 80 {
    print("80점 이상입니다.")
} else if score >= 90 {
    print("90점 이상입니다.")
} else {
    print("70점 미만입니다.")
}

// 올바른 예시(범위가 작은 조건이 먼저 와야 한다)
if score >= 90 {
    print("90점 이상입니다.")
} else if score >= 80 {
    print("80점 이상입니다.")
} else if score >= 70 {
    print("70점 이상입니다.")
} else {
    print("70점 미만입니다.")
}

/*
 3) 조건을 &&와 ||로 연결하는 것도 가능하다
 */
var email = "index@gmail.com"
var passward = "1234"

if email == "index@gmail.com" && passward == "1234" {
    print("로그인 성공")
}

if email != "index@gmail.com" || passward != "1234" {
    print("로그인 실패")
}
