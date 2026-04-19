//
//  StudyListView.swift
//  Swift-Lab
//
//  Created by 김동현 on 4/19/26.
//

import SwiftUI

struct StudyListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("UIKit") {
                    NavigationLink("UICollectionView 기본") {
                        CollectionBasicVC.toSwiftUI()
                    }
                }
            }
        }
    }
}

#Preview {
    RxListView()
}

