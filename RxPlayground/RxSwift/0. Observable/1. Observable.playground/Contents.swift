import RxSwift

// https://babbab2.tistory.com/188

// MARK: - Empty
/// - 어떠한 항목(Item)도 방출(emit)하지 않고, 즉시 onCompleted()를 호출하여 `정상적으로 종료되는 Observable`을 생성
let observableEmpty = Observable<Void>.empty()
observableEmpty.subscribe(onNext: { data in
    print(data)
},
onCompleted: {
    print("onCompleted")
},
onDisposed: {
    print("onDisposed")
})

// MARK: - Never
/// - 어떠한 항목(Item)도 방출(emit)하지 않고 스트림이 종료되지 않는 Observable을 생성한다.
/// - 어떠한 이벤트 항목을 방출하지 않는다는 점에서 empty와 동일하나 empty는 즉시 onCompleted()을 호출시켜 스트림을 정상종료시킨다.
/// - 반면 never는 onCompleted()도 호출시키지 않아 스트림이 종료되지 않는다.
/// 직접 dispose시켜주거나 disposeBag을 이용해 dispose되기 전까진 스트림이 종료되지 않는다. 무한정 지속성을 나타낼 때 사용한다.
let disposeBag = DisposeBag()
let observable_never = Observable<Void>.never()
observable_never.subscribe(onNext: { data in
    print(data)
},
onCompleted: {
    print("onCompleted")
},
onDisposed: {
    print("onDisposed")
})
.disposed(by: disposeBag)
// 아무런 결과값이 찍히지 않는다
// 이유: 이벤트 방출하지도, completed을 통해 정상종료도 하지 않았기 때문.
// dispose될때 onDisposed실행되며 스트림이 종료된다

// MARK: - Range
/// 0부터 5번만큼 정수를 방출하고 onComplete가 불리고 dispose된다
print("\n==== Range ====")
let ovservable_range = Observable.range(start: 0, count: 5)
ovservable_range.subscribe(onNext: { data in
    print(data)
},
onCompleted: {
    print("onCompleted")
},
onDisposed: {
    print("onDisposed")
})
.disposed(by: disposeBag)

// MARK: - Interval
/// 주어진 시간 간격으로 순서대로 정수를 발행하는 Observable을 생성한다
/// 구독 해제 전까지 이벤트를 무한 방출하기 때문에 불필요시 dispise해준다
print("\n==== Interval ====")
let observable_interval = Observable<Int>
    .interval(.seconds(1), scheduler: MainScheduler.instance)
observable_interval
    .take(3) // 3개만 받고 종료
    .subscribe(onNext: { data in
    print(data)
},
onCompleted: {
    print("onCompleted")
},
onDisposed: {
    print("onDisposed")
})
.disposed(by: disposeBag)

// MARK: - Timer
/// - 구독 시점으로부터 특정 시간 동안 이벤트를 지연시킨 뒤, 지연 된 후 이벤트를 방출 및 onCompleted()호출 및 정상종료
/// - 두번째 파라미터 숨겨져있음, period란 파라미터를 설정해줄 수 있는데 (기본값은 nil)
print("\n==== Timer ====")
let observable_timer = Observable<Int>.timer(.seconds(3), scheduler: MainScheduler.instance)
observable_timer
    .subscribe(onNext: { data in
    print(data)
},
onCompleted: {
    print("onCompleted")
},
onDisposed: {
    print("onDisposed")
})
.disposed(by: disposeBag)

// MARK: - Defer
/// Observer가 구독할 때까지 Observable생성을 지연시킨다
/// Subscrible() 메서드를 호출할 때 Observable을 생성한다
let observable_defer = Observable<String>.deferred {
    return Observable.just("0" + " ➕ defferd")
}

