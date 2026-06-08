//
//  SampleDiffView.swift
//  Swift-Lab
//
//  Created by 김동현 on 5/28/26.
//
// https://velog.io/@pzl/1y6778
// https://kka7.tistory.com/670
// https://green1229.tistory.com/589
// https://medium.com/@sunghyun_kim/같은-swiftui인데-왜-내-앱만-버벅일까-6922dd5992c8
// https://velog.io/@jwlee010523/SwiftUI-View-Performance
// https://lzufs.tistory.com/2
// https://eunjin3786.tistory.com/559
// https://sujinnaljin.medium.com/swiftui-view를-redraw-하는-조건은-어떻게-될까-db3d7551df2

import SwiftUI

//struct SampleDiffView: View {
//    @State private var isOn = true
//    var body: some View {
//        VStack(spacing: 20) {
//            Text(isOn ? "On" : "Off")
//                .font(.title2.weight(.semibold))
//                .frame(maxWidth: .infinity)
//                .randomColorStyle()
//            
//            Button {
//                isOn.toggle()
//            } label: {
//                Text("버튼")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity)
//            }
//            .randomColorStyle()
//        }
//        .padding(24)
//    }
//}

struct SampleDiffView: View {
    @State private var isOn = true
    var body: some View {
        VStack(spacing: 20) {
            Text(isOn ? "On" : "Off")
                .frame(maxWidth: .infinity)
                .randomColorStyle()
            
            Button {
                isOn.toggle()
            } label: {
                Text("버튼")
                    .frame(maxWidth: .infinity)
            }
            .randomColorStyle()
        }
        .padding(24)
    }
}

#Preview {
    SampleDiffView()
}
