import RxSwift

/**
 https://brunch.co.kr/@eunjin3786/254
 
 */

let disposeBag = DisposeBag()

// AS IS
let observable = Observable<Int>
    .interval(.seconds(1), scheduler: MainScheduler.instance)

observable
    .take(3)
    .subscribe(onNext: { value in
    print("value: \(value)")
}, onError: {
    print("error: \($0)")
}, onCompleted: {
    
}, onDisposed: {
    
})
.disposed(by: disposeBag)

// TO BE
let observable_async = Observable<Int>
    .interval(.seconds(1), scheduler: MainScheduler.instance)
    .take(3)

Task {
    do {
        for try await value in observable_async.values {
            print("value: \(value)")
        }
    } catch {
        print("error: \(error)")
    }
}
