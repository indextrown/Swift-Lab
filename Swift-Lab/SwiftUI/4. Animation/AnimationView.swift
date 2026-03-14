//
//  AnimationView.swift
//  Swift-Lab
//
//  Created by 김동현 on 3/15/26.
//

import SwiftUI

/*
struct AnimationView: View {
    var body: some View {
        VStack {
            Button {

            } label: {

                HStack(spacing: 12) {

                    Circle()
                        .fill(Color.blue)
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading) {
                        Text("IBK기업은행 계좌")
                            .font(.caption)

                        Text("?원")
                            .font(.headline)
                    }

                    Spacer()

                    Text("송금")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                .contentShape(Rectangle())
            }
            .buttonStyle(TossRowStyle())
        }
    }
}

#Preview {
    AnimationView()
}

struct TossRowStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {

        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isPressed ?
                          Color.gray.opacity(0.15) :
                          Color.clear)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(
                .easeOut(duration: 0.12),
                value: configuration.isPressed
            )
    }
}
*/

struct Account: Identifiable {
    let id = UUID()
    let bank: String
    let balance: String
    let color: Color
}

let accounts: [Account] = [
    Account(bank: "IBK기업은행 계좌", balance: "?원", color: .blue),
    Account(bank: "내 모든 계좌", balance: "잔액 보기", color: .orange),
    Account(bank: "투자 · 토스증권", balance: "잔액 보기", color: .blue.opacity(0.6))
]

struct TossRowButton<Content: View>: View {

    let action: () -> Void
    let content: Content
    
    @State private var isPressed = false

    init(
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.action = action
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isPressed ? Color.gray.opacity(0.15) : .clear)
            )
            .scaleEffect(isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: isPressed)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed { isPressed = true }
                    }
                    .onEnded { _ in
                        isPressed = false
                        action()
                    }
            )
    }
}

struct AnimationView: View {
    
    var body: some View {
        
        VStack(spacing: 12) {
            
            ForEach(accounts) { account in
                
                TossRowButton {
                    print(account.bank)
                } content: {
                    
                    HStack(spacing: 12) {
                        
                        Circle()
                            .fill(account.color)
                            .frame(width: 44, height: 44)
                        
                        VStack(alignment: .leading) {
                            Text(account.bank)
                                .font(.caption)
                            
                            Text(account.balance)
                                .font(.headline)
                        }
                        
                        Spacer()
                        
                        Text("송금")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    AnimationView()
}
