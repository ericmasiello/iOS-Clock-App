//
//  LoadingView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 12/16/24.
//

import SwiftUI

struct LoadingView: View {
  var body: some View {
    VStack {
      ProgressView()
        .scaleEffect(2)
    }
  }
}

#Preview {
  LoadingView()
    .preferredColorScheme(.dark)
}
