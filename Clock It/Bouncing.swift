//
//  Bouncing.swift
//  Clock It
//
//  Created by Eric Masiello on 10/21/24.
//

import SwiftUI

// THIS IS A SIMPLE DEMO
struct BouncingTextView: View {
    @State private var position: CGPoint = CGPoint(x: 100, y: 100)
    @State private var velocity: CGSize = CGSize(width: 4, height: 4)
    @State private var screenSize: CGSize = CGSize(width: 300, height: 600) // Default size

    @State private var textSize: CGSize = CGSize.zero // Approximate text size for bounce logic
    let frameRate = 20.0 / 60.0 // 60 FPS
    let animationDuration = 1.00 // Control speed of animation

    var body: some View {
        GeometryReader { geometry in
            let fullScreenSize = geometry.size
            
            Text("Hello world")
                .font(.largeTitle)
                .background(GeometryReader { textGeometry in
                                    Color.red
                                        .onAppear {
                                            textSize = textGeometry.size // Measure text size
                                        }
                                })
                .position(position)
                
                .onAppear {
                    screenSize = fullScreenSize // Set screen size initially
                    
                    Timer.scheduledTimer(withTimeInterval: frameRate, repeats: true) { _ in
                        withAnimation(.linear(duration: animationDuration)) {
                            moveText()
                        }
                    }
                    
                   
                }
        }
        .edgesIgnoringSafeArea(.all) // To cover full screen area
    }

    func moveText() {
        var newPos = position
        var newVelocity = velocity

        // Update position based on velocity
        newPos.x += newVelocity.width
        newPos.y += newVelocity.height

        // Bounce off the horizontal edges
        if newPos.x - textSize.width / 2 <= 0 || newPos.x + textSize.width / 2 >= screenSize.width {
            newVelocity.width = -newVelocity.width
        }

        // Bounce off the vertical edges
        if newPos.y - textSize.height / 2 <= 0 || newPos.y + textSize.height / 2 >= screenSize.height {
            newVelocity.height = -newVelocity.height
        }

        // Apply updates
        position = newPos
        velocity = newVelocity
    }
}

struct BouncingRectangleView: View {
    @State private var position: CGPoint = CGPoint(x: 100, y: 100)
    @State private var velocity: CGSize = CGSize(width: 4, height: 4)
    @State private var screenSize: CGSize = CGSize(width: 300, height: 600) // Default size
    
    let rectSize: CGSize = CGSize(width: 100, height: 50) // Arbitrary rectangle size
    let frameRate = 1.0 / 60.0 // 60 FPS

    var body: some View {
        GeometryReader { geometry in
            let fullScreenSize = geometry.size
            
            Rectangle()
                .frame(width: rectSize.width, height: rectSize.height)
                .position(position)
                .onAppear {
                    screenSize = fullScreenSize // Set screen size initially
                    Timer.scheduledTimer(withTimeInterval: frameRate, repeats: true) { _ in
                        moveRectangle()
                    }
                }
        }
        .edgesIgnoringSafeArea(.all) // To cover full screen area
    }

    func moveRectangle() {
        var newPos = position
        var newVelocity = velocity

        // Update position based on velocity
        newPos.x += newVelocity.width
        newPos.y += newVelocity.height

        // Bounce off the horizontal edges
        if newPos.x - rectSize.width / 2 <= 0 || newPos.x + rectSize.width / 2 >= screenSize.width {
            newVelocity.width = -newVelocity.width
        }

        // Bounce off the vertical edges
        if newPos.y - rectSize.height / 2 <= 0 || newPos.y + rectSize.height / 2 >= screenSize.height {
            newVelocity.height = -newVelocity.height
        }

        // Apply updates
        position = newPos
        velocity = newVelocity
    }
}

#Preview {
    Group {
        BouncingTextView()
//        BouncingRectangleView()
    }
}
