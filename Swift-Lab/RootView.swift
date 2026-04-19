//
//  ㅜㅁ퍟ㅁ샤ㅐㅜ.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/31/26.
//

import SwiftUI

struct RootView: View {
    @State private var path: [Int] = []

    var body: some View {
        print("🔥 RootView body")

        return NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Text("Root")

                Button("Push 1") {
                    path.append(1)
                }

                Button("Push 2") {
                    path.append(2)
                }
            }
            .navigationDestination(for: Int.self) { value in
                DetailView(value: value)
            }
        }
    }
}

struct DetailView: View {
    let value: Int

    var body: some View {
        print("🔥 DetailView body: \(value)")

        return VStack(spacing: 20) {
            Text("Detail \(value)")

            NavigationLink("Push Next", value: value + 1)
        }
    }
}
