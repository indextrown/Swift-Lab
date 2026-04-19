//
//  ContentView.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/19/26.
//

import SwiftUI

struct TabBar: View {
    
    @State private var selectedTab: Int = 4
    var body: some View {
        TabView(selection: $selectedTab) {
            SwiftUIListView()
                .tabItem {
                    Label("SwiftUI", systemImage: "1.square.fill")
                }
                .tag(1)
            
            UIKitListViewController
                .toSwiftUI(withNavigation: true)
                .tabItem {
                    Label("UIKit", systemImage: "2.square.fill")
                }
                .tag(2)
            
            RxListView()
                .tabItem {
                    Label("RxSwift", systemImage: "3.square.fill")
                }
                .tag(3)
            
            ReactorKitListView()
                .tabItem {
                    Label("ReactorKit", systemImage: "4.square.fill")
                }
                .tag(4)
            
            StudyListView()
                .tabItem {
                    Label("Study", systemImage: "4.square.fill")
                }
                .tag(5)
        }
    }
}

#Preview {
    TabBar()
}
