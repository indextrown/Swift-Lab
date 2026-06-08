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
                Section("UICollectionView") {
                    NavigationLink("Basic") {
                        CollectionBasicVC.toSwiftUI()
                    }
                    NavigationLink("Pagination") {
                        PaginationVC.toSwiftUI()
                    }
                    NavigationLink("Prefetching") {
                        PrefetchingVC.toSwiftUI()
                    }
                    NavigationLink("Pull to Refresh") {
                        PullToRefreshVC.toSwiftUI()
                    }
                    NavigationLink("CompositionalLayout") {
                        CompositionalLayoutBasicVC.toSwiftUI(isNavigationBarHidden: true)
                    }
                }
                
                Section("Adapter") {
                    NavigationLink("Basic") {
                        // BasicAdapterVC.toSwiftUI(isNavigationBarHidden: true)
                    }
                    
//                    NavigationLink("Light") {
//                        LightVC.toSwiftUI(isNavigationBarHidden: true)
//                    }
                }
            }
        }
    }
}

#Preview {
    RxListView()
}
