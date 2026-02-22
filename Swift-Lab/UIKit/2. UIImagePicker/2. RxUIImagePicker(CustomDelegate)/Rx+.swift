//
//  Rx+.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/22/26.
//

/*
 https://github.com/ReactiveX/RxSwift/blob/main/RxExample/RxExample/Examples/ImagePicker/ImagePickerController.swift
 */
import UIKit
import RxSwift
import RxCocoa

extension UIImagePickerController {

    static func rxPick(
        parent: UIViewController,
        source: UIImagePickerController.SourceType
    ) -> Observable<UIImage> {

        return Observable.create { observer in
            MainScheduler.ensureRunningOnMainThread()

            let picker = UIImagePickerController()
            picker.sourceType = source
            picker.allowsEditing = false

            final class Delegate: NSObject,
                            UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate {

                let observer: AnyObserver<UIImage>

                init(observer: AnyObserver<UIImage>) {
                    self.observer = observer
                }

                func imagePickerController(
                    _ picker: UIImagePickerController,
                    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
                ) {
                    if let image = info[.originalImage] as? UIImage {
                        observer.onNext(image)
                        observer.onCompleted()
                    }
                    picker.dismiss(animated: true)
                }

                func imagePickerControllerDidCancel(
                    _ picker: UIImagePickerController
                ) {
                    observer.onCompleted()
                    picker.dismiss(animated: true)
                }
            }

            let delegate = Delegate(observer: observer)
            picker.delegate = delegate

            // 🔥 delegate 유지 (중요)
            objc_setAssociatedObject(
                picker,
                "[rx_delegate]",
                delegate,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )

            parent.present(picker, animated: true)

            return Disposables.create {
                picker.dismiss(animated: true)
            }
        }
    }
    
}














///*
// [기본 Delegate 패턴]
// - picker.delegate = self
// - 이벤트 발생 시 UIKit이 delegate 객체(self)를 직접 호출 func imagePickerController(...)
// - UIImagePickerController  ───▶  delegate (self)
// 
// [DelegateProxy]
// - UIKit의 delegate를 가로채서 Observable로 바꿔주는 중간 관리자 객체
// 
// [RxDelegate]
// - Rx는 Delegate대신 Ovservable로 만든다
// - DelegateProxy가 delegate 자리에 대신 들어감
// - UIImagePickerController -> DelegateProxy -> Observable stream -> subscribe
// 
// */
// import UIKit
// import RxSwift
// import RxCocoa
//
// // 이미지 선택 / 취소를 Observable로 래핑
// // - RxCocoa의 DelegateProxy가 자동으로 delegate연결해줌
// // - picker.delegate = self 안해도 됨
// extension Reactive where Base: UIImagePickerController {
//     var didFinishPickingImage: Observable<UIImage> {
//         return delegate
//             .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:))) // Observable<[Any]>
//             .compactMap { paraeters in
//                 let info = paraeters[1] as? [UIImagePickerController.InfoKey: Any]
//                 return info?[.originalImage] as? UIImage
//             }
//     }
//     
//     var didCancel: Observable<Void> {
//         return delegate
//             .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
//             .map { _ in () }
//     }
// }
//
// extension Reactive where Base: UIViewController {
//     func pickImage(source: UIImagePickerController.SourceType) -> Observable<UIImage> {
//         Observable.create { [weak base] observer in
//             guard let vc = base else {
//                 observer.onCompleted()
//                 return Disposables.create()
//             }
//             
//             guard UIImagePickerController.isSourceTypeAvailable(source) else {
//                 observer.onCompleted()
//                 return Disposables.create()
//             }
//             
//             let picker = UIImagePickerController()
//             picker.sourceType = source
//             picker.allowsEditing = false
//             vc.present(picker, animated: true)
//             
//             let finish = picker.rx.didFinishPickingImage
//                 .subscribe(onNext: { image in
//                     observer.onNext(image)
//                     observer.onCompleted()
//                     picker.dismiss(animated: true)
//                 })
//             
//             let cancel = picker.rx.didCancel
//                 .subscribe(onNext: {
//                     observer.onCompleted()
//                     picker.dismiss(animated: true)
//                 })
//             
//             return Disposables.create {
//                 finish.dispose()
//                 cancel.dispose()
//             }
//         }
//     }
// }





//
//  Rx+.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/22/26.
//
/*
 [기본 Delegate 패턴]
 - picker.delegate = self
 - 이벤트 발생 시 UIKit이 delegate 객체(self)를 직접 호출 func imagePickerController(...)
 - UIImagePickerController  ───▶  delegate (self)
 
 [DelegateProxy]
 - UIKit의 delegate를 가로채서 Observable로 바꿔주는 중간 관리자 객체
 
 [RxDelegate]
 - Rx는 Delegate대신 Ovservable로 만든다
 - DelegateProxy가 delegate 자리에 대신 들어감
 - UIImagePickerController -> DelegateProxy -> Observable stream -> subscribe
 
 */
// import UIKit
// import RxSwift
// import RxCocoa
//
// // 이미지 선택 / 취소를 Observable로 래핑
// // - RxCocoa의 DelegateProxy가 자동으로 delegate연결해줌
// // - picker.delegate = self 안해도 됨
// extension Reactive where Base: UIImagePickerController {
//     var didFinishPickingImage: Observable<UIImage> {
//         return delegate
//             .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:))) // Observable<[Any]>
//             .compactMap { paraeters in
//                 let info = paraeters[1] as? [UIImagePickerController.InfoKey: Any]
//                 return info?[.originalImage] as? UIImage
//             }
//     }
//     
//     var didCancel: Observable<Void> {
//         return delegate
//             .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
//             .map { _ in () }
//     }
// }
//
// extension Reactive where Base: UIViewController {
//     func pickImageWithActionSheet() -> Observable<UIImage> {
//         selectImageSource()
//             .flatMapLatest { [weak base] source -> Observable<UIImage> in
//                 guard let base else { return .empty() }
//                 return base.rx.pickImage(source: source)
//             }
//     }
//     
//     func selectImageSource() -> Observable<UIImagePickerController.SourceType> {
//         Observable.create { [weak base] observer in
//             guard let vc = base else {
//                 observer.onCompleted()
//                 return Disposables.create()
//             }
//             
//             let alert = UIAlertController(title: "선택",
//                                           message: nil,
//                                           preferredStyle: .actionSheet)
//             
//             alert.addAction(UIAlertAction(title: "카메라", style: .default) { _ in
//                 observer.onNext(.camera)
//                 observer.onCompleted()
//             })
//                             
//             alert.addAction(UIAlertAction(title: "앨범", style: .default) { _ in
//                 observer.onNext(.photoLibrary)
//                 observer.onCompleted()
//             })
//             
//             alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
//                 observer.onNext(.camera)
//                 observer.onCompleted()
//             })
//             
//             vc.present(alert, animated: true)
//             return Disposables.create()
//         }
//     }
//     
//     func pickImage(source: UIImagePickerController.SourceType) -> Observable<UIImage> {
//         Observable.create { [weak base] observer in
//             guard let vc = base else {
//                 observer.onCompleted()
//                 return Disposables.create()
//             }
//             
//             guard UIImagePickerController.isSourceTypeAvailable(source) else {
//                 observer.onCompleted()
//                 return Disposables.create()
//             }
//             
//             let picker = UIImagePickerController()
//             picker.sourceType = source
//             picker.allowsEditing = false
//             picker.delegate = picker.rx.delegate
//             vc.present(picker, animated: true)
//             
//             let finish = picker.rx.didFinishPickingImage
//                 .subscribe(onNext: { image in
//                     observer.onNext(image)
//                     observer.onCompleted()
//                     picker.dismiss(animated: true)
//                 })
//             
//             let cancel = picker.rx.didCancel
//                 .subscribe(onNext: {
//                     observer.onCompleted()
//                     picker.dismiss(animated: true)
//                 })
//             
//             return Disposables.create {
//                 finish.dispose()
//                 cancel.dispose()
//             }
//         }
//     }
// }

