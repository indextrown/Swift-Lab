//
//  SwiftUIListView.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/19/26.
//

import SwiftUI

struct SwiftUIListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("리스트뷰") {
                    NavigationLink("리스트") {
                        ListView()
                    }
                }
            }
        }
    }
}

#Preview {
    SwiftUIListView()
}
