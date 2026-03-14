//
//  Section.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/23/26.
//

import RxDataSources

struct AnimatedNumberItem {
    let id: Int
    let value: Int
}
extension AnimatedNumberItem: IdentifiableType, Equatable {
    var identity: Int { id }
}

struct AnimatedNumberSection {
    var header: String
    var items: [AnimatedNumberItem]
}

extension AnimatedNumberSection: AnimatableSectionModelType {
    var identity: String { header }
    init(original: AnimatedNumberSection, items: [AnimatedNumberItem]) {
        self = original
        self.items = items
    }
}

