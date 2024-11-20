import SwiftUI

//
//  BounceView.swift
//  Clock It
//
//  Created by Eric Masiello on 10/31/24.
//

struct BounceView<Content: View>: View {
  @ViewBuilder let content: Content
  @State private var position: CGPoint = .init(x: 0, y: 0)
  @State private var velocity: CGSize = .init(width: 4, height: 4)
  @State private var screenSize: CGSize = .init(width: 0, height: 0) // Default size
  @State private var viewSize: CGSize = .init(width: 0, height: 0)
  let animationDuration = 1.00 // Control speed of animation

  func updatePositionAndVelocity() {
    var newPos = position
    var newVelocity = velocity

    // Update position based on velocity
    newPos.x += newVelocity.width
    newPos.y += newVelocity.height

    // Bounce off the horizontal edges
    if newPos.x - viewSize.width / 2 <= 0 || newPos.x + viewSize.width / 2 >= screenSize.width {
      newVelocity.width = -newVelocity.width
    }

    // Bounce off the vertical edges
    if newPos.y - viewSize.height / 2 <= 0 || newPos.y + viewSize.height / 2 >= screenSize.height {
      newVelocity.height = -newVelocity.height
    }

    // Apply updates
    position = newPos
    velocity = newVelocity
  }

  var body: some View {
    content.background(GeometryReader { contentViewProxy in
      Color.clear
        .onAppear {
          debugPrint("Running Child BounceView onAppear")
          debugPrint("Total width \(UIScreen.main.bounds.width)")
          debugPrint("Content view width \(contentViewProxy.size.width)")
          viewSize = contentViewProxy.size // Measure view size
        }
    })
    .position(position)
    .onAppear {
      debugPrint("Running outer BounceView onAppear")
      screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
      position.x = UIScreen.main.bounds.midX
      position.y = UIScreen.main.bounds.midY

      Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { _ in
        withAnimation(.linear(duration: animationDuration)) {
          // skip animating until the viewSize is updated by the child view
          if viewSize.width > 0 && viewSize.height > 0 {
            updatePositionAndVelocity()
          }
        }
      }
    }
  }
}

#Preview {
  BounceView {
    VStack(alignment: .leading, spacing: 0) {
      EmojiView(option: .rain, size: 100)
      ClockView(size: 100, viewMode: .active, now: Date())
      HStack {
        Spacer()
        TemperatureView(temperatureF: 24.3)
      }
    }
    .fixedSize()
  }
  .preferredColorScheme(.dark)
}
