//import SwiftUI
//
//struct DiffingView: View {
//    @State private var isOn = true
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            
////            Text("NO MATTER!")
////                .background(Color.random)
//            
//            NoMatterText()
//            
//            Text(isOn ? "On" : "OFF")
//                .background(Color.random)
//            
//            Button {
//                isOn.toggle()
//            } label: {
//                Text("🔦")
//            }
//            .background(Color.random)
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    DiffingView()
//}
//
//struct NoMatterText: View {
//    
//    var body: some View {
//        Text("NO MATTER!")
//            .background(Color.random)
//    }
//}
//
//extension Color {
//    static var random: Color {
//        Color(
//            red: .random(in: 0...1),
//            green: .random(in: 0...1),
//            blue: .random(in: 0...1)
//        )
//    }
//}


import SwiftUI

final class RenderCounter: ObservableObject {
    @Published var count: Int = 0
    
    func increase() {
        count += 1
    }
}

struct TestRowView: View, Equatable {
    let value: Int
    let counter: RenderCounter
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
    
    var body: some View {
        counter.increase() // 🔥 body 실행 카운트
        return Text("\(value)")
    }
}

struct TestListView: View {
    @State var items: [Int]
    let counter: RenderCounter
    
    var body: some View {
        List(items, id: \.self) { item in
            TestRowView(value: item, counter: counter)
        }
    }
}

struct PreviewWrapper: View {
    @State private var items = Array(0..<20)
    @StateObject private var counter = RenderCounter()
    
    var body: some View {
        VStack {
            TestListView(items: items, counter: counter)
            
            Text("Render Count: \(counter.count)")
            
            Button("Change First Item") {
                items[0] = Int.random(in: 100...999)
            }
        }
    }
}

#Preview {
    PreviewWrapper()
}



//struct Row: View, Equatable {
//    let item: Item
//    let action: () -> Void
//
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        // 매번 직접 작성해야 함
//        lhs.item == rhs.item
//    }
//}
//
//
