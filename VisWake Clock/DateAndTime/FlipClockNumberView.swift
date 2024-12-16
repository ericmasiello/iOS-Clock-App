//
//  FlipClockNumberView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/21/24.
//

import SwiftUI

struct FlipClockNumberView: View {
  var value: String
  var size: CGFloat = 130
  var color: Color?
  var body: some View {
    Text("\(value)")
      .font(.system(size: size * 1.05, weight: .bold, design: .default))
      .monospaced()
      .foregroundColor(.white)
      .frame(width: size * 0.9, height: size * 1.2)
      .background(color ?? .gray.opacity(0.25))
      .cornerRadius(15)
  }
}

#Preview {
  Group {
    FlipClockNumberView(value: "8", size: 50, color: .yellow)
    FlipClockNumberView(value: "8", size: 50)
  }
  .preferredColorScheme(.dark)
}
