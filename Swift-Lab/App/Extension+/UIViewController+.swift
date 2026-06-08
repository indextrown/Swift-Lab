//
//  UIViewController+.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/19/26.
//

/*
 self: 객체
 Self: 타입
 Self.self: 타입을 값으로 사용
 UIViewController.Type: UIViewController 타입을 담는 타입(UIViewController 또는 그 하위 클래스의 타입)
 
 // MyVC는 UIViewController를 상속했기 때문
 let type1: UIViewController.Type = UIViewController.self
 let type2: UIViewController.Type = MyVC.self

 */
import UIKit
import SwiftUI

extension UIViewController {
    struct VCWrapper: UIViewControllerRepresentable {
        let vcType: UIViewController.Type
        let withNavigation: Bool
        let isNavigationBarHidden: Bool
        
        func makeUIViewController(context: Context) -> UIViewController {
            let rootVC = vcType.init()
            guard withNavigation else { return rootVC }

            let navigationController = UINavigationController(rootViewController: rootVC)
            navigationController.setNavigationBarHidden(isNavigationBarHidden, animated: false)
            return navigationController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            guard let navigationController = uiViewController as? UINavigationController else { return }
            navigationController.setNavigationBarHidden(isNavigationBarHidden, animated: false)
        }
    }
    
    static func toSwiftUI(
        withNavigation: Bool = true,
        isNavigationBarHidden: Bool = false
    ) -> some View {
        return VCWrapper(
            vcType: Self.self,
            withNavigation: withNavigation,
            isNavigationBarHidden: isNavigationBarHidden
        )
    }
}


extension UIViewController {
    struct ReactorVCWrapper: UIViewControllerRepresentable {
        let makeViewController: () -> UIViewController
        let withNavigation: Bool
        let isNavigationBarHidden: Bool
        
        func makeUIViewController(context: Context) -> UIViewController {
            let rootVC = makeViewController()
            guard withNavigation else { return rootVC }

            let navigationController = UINavigationController(rootViewController: rootVC)
            navigationController.setNavigationBarHidden(isNavigationBarHidden, animated: false)
            return navigationController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            guard let navigationController = uiViewController as? UINavigationController else { return }
            navigationController.setNavigationBarHidden(isNavigationBarHidden, animated: false)
        }
    }
    
    static func toSwiftUI(
        withNavigation: Bool = true,
        isNavigationBarHidden: Bool = false,
        makeViewController: @escaping () -> UIViewController
    ) -> some View {
        ReactorVCWrapper(
            makeViewController: makeViewController,
            withNavigation: withNavigation,
            isNavigationBarHidden: isNavigationBarHidden
        )
    }
}


