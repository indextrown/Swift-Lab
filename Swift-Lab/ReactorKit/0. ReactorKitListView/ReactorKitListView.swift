//
//  RxListView.swift
//  Swift-Lab
//
//  Created by 김동현 on 2/19/26.
//

import SwiftUI

struct ReactorKitListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("ReactorKit") {
                    NavigationLink("CounterVC") {
                        CounterVC.toSwiftUI {
                            CounterVC(reactor: CounterViewReactor())
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RxListView()
}

