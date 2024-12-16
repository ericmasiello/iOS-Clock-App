//
//  TimeView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/31/24.
//

import SwiftUI

struct TimeView<Content: View>: View {
  @ViewBuilder let content: (Date) -> Content
  @State private var now = Date()
  private let clockTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    content(now)
      .onReceive(clockTimer) { input in
        now = input
      }
  }
}

#Preview {
  TimeView { now in
    Text("\(now)")
  }
  .preferredColorScheme(.dark)
}
