import SwiftUI

//
//  BounceView.swift
//  Clock It
//
//  Created by Eric Masiello on 10/31/24.
//


struct BounceView<Content: View>: View {
    @ViewBuilder let content: Content
    @State private var position: CGPoint = CGPoint(x: 0, y: 0)
    @State private var velocity: CGSize = CGSize(width: 4, height: 4)
    @State private var screenSize: CGSize = CGSize(width: 0, height: 0) // Default size
    @State private var viewSize: CGSize = CGSize(width: 0, height: 0)
    let frameRate = 20.0 / 60.0 // 60 FPS
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
                debugPrint("Total width \(UIScreen.main.bounds.width)")
                debugPrint("Content view width \(contentViewProxy.size.width)")
                viewSize = contentViewProxy.size // Measure view size
            }
        })
        .position(position)
        .onAppear {
            screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            position.x = UIScreen.main.bounds.midX
            position.y = UIScreen.main.bounds.midY
            
            Timer.scheduledTimer(withTimeInterval: frameRate, repeats: true) { _ in
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

#Preview("Active") {
    BounceView {
        SizedContentView(viewMode: .active, temperatureF: 54.2, now: Date())
    }
    .preferredColorScheme(.dark)
}


#Preview("Dim") {
    BounceView {
        SizedContentView(viewMode: .dim, temperatureF: 54.2, now: Date())
    }
    .preferredColorScheme(.dark)
}
