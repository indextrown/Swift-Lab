//
//  TurboList.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/15/26.
//

import SwiftUI

public struct TurboList<Content: View>: View {
    
    private let spacing: CGFloat
    private let views: [AnyView]
    
    public init(
        spacing: CGFloat = 0,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.views = TurboList.flatten(content())
    }
    
    public var body: some View {
        
    }
}

// MARK: - Flatten
extension TurboList {
    static func flatten<V: View>(_ view: V) -> [AnyView] {
        let mirror = Mirror(reflecting: view)
        
        if mirror.displayStyle == .tuple {
            return mirror.children.compactMap {
                AnyView(_fromValue: $0.value)
            }
        }
        
        return [AnyView(view)]
    }
}

//struct TurboListRepresentable: UIViewRepresentable {
//    let views: [AnyView]
//    let spacing: CGFloat
//    
//    func makeUIView(
//        context: UIViewRepresentableContext<Self>
//    ) -> UICollectionView {
//        
//    }
//    
//    func updateUIView(
//        _ uiView: UICollectionView,
//        context: UIViewRepresentableContext<Self>
//    ) {
//        
//    }
//}
//
//extension TurboListRepresentable {
//    func makeCoordinator() -> Coordinator {
//        
//    }
//}
