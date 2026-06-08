////
////  AnyComponent.swift
////  Swift-Lab
////
////  Created by 김동현 on 4/28/26.
////
//
//import UIKit
//
//private protocol ComponentBox {
//    
//    //
//    associatedtype Base: Component
//    var base: Base { get }
//    var reuseIdentifier: String { get }
//    var layoutMode: ContentLayoutMode { get }
//    var viewModel: Base.ViewModel { get }
//    
//    func renderContent(coordinator: Any) -> UIView
//    func render(in content: UIView, coordinator: Any)
//    func layout(content: UIView, in container: UIView)
//    func makeCoordinator() -> Any
//}
//
//private struct AnyComponentBox<Base: Component>: ComponentBox {
//    
//    let base: Base
//    
//    /// 재사용 식별자
//    var reuseIdentifier: String { base.reuseIdentifier }
//    
//    /// 레이아웃 모드
//    var layoutMode: ContentLayoutMode { base.layoutMode }
//    
//    /// ViewModel
//    var viewModel: Base.ViewModel { base.viewModel }
//    
//    /// 실제 `Component`를 감싸는 Box 구현체
//    init(_ base: Base) {
//        self.base = base
//    }
//    
//    func renderContent(coordinator: Any) -> UIView {
//        base.renderContent(coordinator: coordinator as! Base.Coordinator)
//    }
//    
//    func render(in content: UIView, coordinator: Any) {
//        guard let content = content as? Base.Content,
//              let coordinator = coordinator as? Base.Coordinator else {
//            return
//        }
//        base.render(in: content, coordinator: coordinator)
//    }
//    
//    func layout(content: UIView, in container: UIView) {
//        guard let content = content as? Base.Content else { return }
//        base.layout(content: content, in: container)
//    }
//    
//    func makeCoordinator() -> Any {
//        base.makeCoordinator()
//    }
//}
//
//struct AnyComponent {
//    private let box: any ComponentBox
//    
//    var reuseIdentifier: String { box.reuseIdentifier }
//    
//    init(_ base: some Component) {
//        self.box = AnyComponentBox(base)
//    }
//    
//    func renderContent(coordinator: Any) -> UIView {
//        box.renderContent(coordinator: coordinator)
//    }
//    
//    func render(in content: UIView, coordinator: Any) {
//        box.render(in: content, coordinator: coordinator)
//    }
//    
//    func layout(content: UIView, in container: UIView) {
//        box.layout(content: content, in: container)
//    }
//
//    func makeCoordinator() -> Any {
//        box.makeCoordinator()
//    }
//}
//
//
//import CoreGraphics
//
//public enum ContentLayoutMode: Equatable {
//    /// 콘텐츠 너비/높이를 컨테이너에 맞춰 꽉 채움
//    case fitContainer
//
//    /// 너비는 컨테이너에 맞추고, 높이는 콘텐츠 크기에 맞게 유동적으로 계산
//    case flexibleHeight(estimatedHeight: CGFloat)
//
//    /// 높이는 컨테이너에 맞추고, 너비는 콘텐츠 크기에 맞게 유동적으로 계산
//    case flexibleWidth(estimatedWidth: CGFloat)
//
//    /// 너비/높이 모두 콘텐츠 크기에 맞게 계산
//    case fitContent(estimatedSize: CGSize)
//}
