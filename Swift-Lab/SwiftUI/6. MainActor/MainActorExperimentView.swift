//
//  MainActorExperimentView.swift
//  Swift-Lab
//
//  Created by 김동현 on 6/3/26.
//

import SwiftUI

struct MainActorExperimentView: View {
    @StateObject private var viewModel = MainActorExperimentViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("MainActor Thread Test")
                    .font(.title2)
                    .bold()
                
                Text(viewModel.labelText)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 12) {
                Button {
                    viewModel.updateLabelWithAsyncAwait()
                } label: {
                    Label("await 비동기 작업", systemImage: "arrow.triangle.2.circlepath")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    viewModel.updateLabelWithSynchronousWork()
                } label: {
                    Label("await 없는 동기 작업", systemImage: "exclamationmark.triangle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            
            Text("Xcode console에서 [MainActorTest] 로그를 확인하세요.")
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding(20)
        .navigationTitle("@MainActor")
    }
}

final class MainActorExperimentViewModel: ObservableObject {
    @Published var labelText = "버튼을 눌러 테스트를 시작하세요."

    @MainActor
    func updateLabelWithAsyncAwait() {
        Self.log("updateLabelWithAsyncAwait() entered")

        Task {
            Self.log("Task start - inherits MainActor")

            let text = await fetchData()

            Self.log("after await - back on MainActor")
            labelText = text
            Self.log("labelText updated")
        }

        Self.log("updateLabelWithAsyncAwait() returned after creating Task")
    }

    @MainActor
    func updateLabelWithSynchronousWork() {
        Self.log("updateLabelWithSynchronousWork() entered")

        let text = makeTextWithHeavySynchronousWork()

        Self.log("after synchronous work - still on MainActor")
        labelText = text
        Self.log("labelText updated")
    }

    private func fetchData() async -> String {
        Self.log("fetchData() start - nonisolated async function")

        try? await Task.sleep(for: .seconds(2))

        Self.log("fetchData() resumed after sleep")
        return "await 작업 완료: \(Date().formatted(date: .omitted, time: .standard))"
    }
    
    private func makeTextWithHeavySynchronousWork() -> String {
        Self.log("heavy synchronous work start")
        
        let startedAt = Date()
        var counter: UInt64 = 0
        
        while Date().timeIntervalSince(startedAt) < 2 {
            counter &+= 1
        }
        
        Self.log("heavy synchronous work end, counter: \(counter)")
        return "동기 작업 완료: \(Date().formatted(date: .omitted, time: .standard))"
    }
    
    private static func log(_ message: String) {
        var threadID: UInt64 = 0
        pthread_threadid_np(nil, &threadID)
        
        let threadName = Thread.isMainThread ? "✅ main" : "❌ background"
        print("[MainActorTest] \(message) | thread: \(threadName) | id: \(threadID)")
    }
}

#Preview {
    NavigationStack {
        MainActorExperimentView()
    }
}
