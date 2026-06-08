////
////  AnyViewModel.swift
////  Swift-Lab
////
////  Created by 김동현 on 4/28/26.
////
//
//import Foundation
//
//public struct AnyViewModel: Equatable {
//    
//    /// 진짜 ViewModel을 꺼내서 base에 저장합니다.
//    private let base: any Equatable
//    
//    /// 주어진 `Component`의 ViewModel을 감싸서 새로운 `AnyViewModel` 인스턴스를 생성합니다.
//    ///
//    /// - Parameter base: 감쌀 Component
//    init(_ base: some Component) {
//        self.base = base.viewModel
//    }
//    
//    /// 두 `AnyViewModel`이 같은지 비교합니다.
//    ///
//    /// - Returns: 같으면 true, 아니면 false
//    public static func == (
//        lhs: AnyViewModel,
//        rhs: AnyViewModel
//    ) -> Bool {
//        return lhs.base.isEqual(rhs.base)
//    }
//}
