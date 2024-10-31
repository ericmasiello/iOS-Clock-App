//
//  FlipClockNumberView.swift
//  Clock It
//
//  Created by Eric Masiello on 10/21/24.
//


import SwiftUI

struct FlipClockNumberView: View {
    var value: String
    var size: CGFloat = 130
    var color: Color?
    var viewMode: ViewMode
    var body: some View {
        Text("\(value)")
            .font(.system(size: size * 1.05, weight: .bold, design: .default))
            .monospaced()
            .foregroundColor(.white)
            .frame(width: size * 0.9, height: size * 1.2)
            .background(color ?? .gray.opacity(viewMode == .dim ? 0 : 0.2))
            .cornerRadius(15)
    }
}

//struct FlipClockNumberView2: View {
//    var value: Character
//    var size: CGFloat
//    var color: Color?
////    var viewMode: ViewMode
//    var body: some View {
//        Text("\(value)")
//            .font(.system(size: size * 1.05, weight: .bold, design: .default))
//            .monospaced()
//            .foregroundColor(.white)
//            .frame(width: size * 0.9, height: size * 1.2)
//            .background(color ?? Color.clear)
//            .cornerRadius(15)
//    }
//}

#Preview {
    Group {
        FlipClockNumberView(value: "8", size: 50, color: .yellow, viewMode: .active)
        FlipClockNumberView(value: "8", size: 50, viewMode: .dim)
//        FlipClockNumberView2(value: "8", size: 50, color: .gray.opacity(0.5))
    }
    .background(Color.black)
}
