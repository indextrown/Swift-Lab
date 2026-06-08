////
////  ComponentContainerCell.swift
////  Swift-Lab
////
////  Created by 김동현 on 4/28/26.
////
//
//import UIKit
//
//final class ComponentContainerCell: UICollectionViewCell {
//    private var renderedContent: UIView?
//    private var coordinator: Any?
//    private var renderedReuseIdentifier: String?
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        if renderedReuseIdentifier == nil {
//            renderedContent?.removeFromSuperview()
//            renderedContent = nil
//            coordinator = nil
//        }
//    }
//    
//    func render(component: AnyComponent) {
//        if renderedReuseIdentifier != component.reuseIdentifier {
//            renderedContent?.removeFromSuperview()
//            renderedContent = nil
//            coordinator = nil
//        }
//
//        if let renderedContent, let coordinator {
//            component.render(
//                in: renderedContent,
//                coordinator: coordinator
//            )
//            renderedReuseIdentifier = component.reuseIdentifier
//            return
//        }
//        
//        let coordinator = component.makeCoordinator()
//        let content = component.renderContent(coordinator: coordinator)
//        component.layout(content: content, in: contentView)
//        component.render(in: content, coordinator: coordinator)
//        self.coordinator = coordinator
//        self.renderedContent = content
//        self.renderedReuseIdentifier = component.reuseIdentifier
//    }
//}
//
//extension ComponentContainerCell: ReuseIdentifiable {}
