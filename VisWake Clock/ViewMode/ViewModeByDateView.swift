//
//  ViewModeByDateView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/31/24.
//
import SwiftUI

struct ViewModeByDateView<Content: View>: View {
  let date: Date
  @ViewBuilder let content: (ViewMode) -> Content

  // TODO: make this configurable somehow by the user
  private var viewMode: ViewMode {
    let hour = date.component(.hour)
    let minutes = date.component(.minute)
    /**
     * Set full opacity if time >= 6:15 and < 8:00 am
     */
    return switch (hour, minutes) {
    case (6, let mins) where mins >= 25, (7, let mins):
      .active
    default:
      .dim
    }
  }

  var body: some View {
    content(viewMode)
  }
}

#Preview {
  ViewModeByDateView(date: .init()) { viewMode in
    switch viewMode {
    case .active:
      Text("Active")
    case .dim:
      Text("Dim")
    }
  }
}
