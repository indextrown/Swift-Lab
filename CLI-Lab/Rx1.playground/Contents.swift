import RxSwift

/**
 [emit]
  - 함수나 타입이 아니라 Observable.onNext(_:)가 호출되는 순간을 말하는 개념
 Observable<Void> { observer in
     observer.onNext(()) // tap 1
     observer.onNext(()) // tap 2
     observer.onNext(()) // tap 3
 }
 
 let observable = button.rx.tap.asObservable()

 observable
     .subscribe(onNext: { value in
         print("tap 발생:", value)
     })
     .disposed(by: disposeBag)
 
 [reference]
 - https://babbab2.tistory.com/185
 */

// MARK: - Just
// - 하나의 항목만 파라미터로 넘겨줄 수 있다
// - Observable을 구독하자면 넣어둔 항목이 방출되고 dispose된다.
let observable = Observable<Int>.just(1)
observable.subscribe(onNext: { data in
    print(data)
},
onCompleted: {
    print("onCompleted")
},
onDisposed: {
    print("onDisposed")
})

// MARK: - of
// of파라미터는 가변 파라미터라서 방출을 원하는 만큼 항목을 넘겨줄 수 있다.
// 파라미터로 넘겨준 항목을 순서대로 방출한다.
// 파라미터 하나를 하나의 항목(item)으로 본다
let observableOf = Observable<Int>.of(1, 2, 3)
observableOf.subscribe(onNext: { data in
    print(data)
},
onCompleted: {
    print("onCompleted")
},
onDisposed: {
    print("onDisposed")
})

// MARK: - Create
// 파라미터로 Observer를 매개변수로 받는 클로저를 전달받는 Observable Sequence를 생성한다
// 매개변수로 받은 Observer의 onNext, onCompleted, onError를 직접 호출할 수 있다
// 클로저가 끝나기 전 반드시 onCompleted나 onError를 정확히 1번 호출해야 하며 그 이후로는 Observer의 다른 어떤 메서드도 호출하면 안된다
// 비동기 이벤트를 Observable로 만들고 결과값을 받고 결과에 따라 onNext나 onError를 마음대로 방출할 수 있다
let observableCreate = Observable<String>.create { observer in
    observer.onNext("첫 번째 방출")
    observer.onNext("두 번째 방출")
    observer.onCompleted()
    observer.onNext("세 번째 방출")
    return Disposables.create()
}
observableCreate.subscribe(onNext: { data in
    print(data)
},
onCompleted: {
    print("onCompleted")
},
onDisposed: {
    print("onDisposed")
})
