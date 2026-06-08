//
//  View+.swift
//  Swift-Lab
//
//  Created by 김동현 on 5/28/26.
//

import SwiftUI

public extension ShapeStyle where Self == Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

extension View {
    func debugViewUpdates(_ label: String = "") -> some View {
        self.background(
            Color.random.opacity(0.3)
                .animation(.easeInOut(duration: 0.2), value: UUID())
        )
        .onAppear {
            print("🔄 View Updated: \(label)")
        }
    }

    func randomColorStyle(
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 12
    ) -> some View {
        self
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.random.opacity(0.35))
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(.ultraThinMaterial)
                    }
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
    }
}
