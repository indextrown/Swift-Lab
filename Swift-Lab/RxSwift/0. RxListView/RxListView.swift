//
//  RxListView.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/19/26.
//

import SwiftUI

struct RxListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("RxSwift") {
                    NavigationLink("Observable") {
                        ObservableView()
                    }
                }
                Section("Rx") {
                    NavigationLink("유저정보") {
                        UserStateVC.toSwiftUI()
                    }
                    
                    NavigationLink("유저정보 + Rx") {
                        RxUserStateVC.toSwiftUI()
                    }
                    
                    NavigationLink("유저정보 + Rx + Inout") {
                        RxInoutUserVC.toSwiftUI()
                    }
                }
            }
        }
    }
}

#Preview {
    RxListView()
}

