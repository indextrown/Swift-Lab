//
//  Section.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/23/26.
//

import RxDataSources

struct NumberSection {
    var header: String
    var items: [Int]
}

extension NumberSection: SectionModelType {
    init(original: NumberSection, items: [Int]) {
        self = original
        self.items = items
    }
}
