//
//  HomeView.swift
//  Clock It
//
//  Created by Eric Masiello on 10/21/24.
//


import SwiftUI

struct HomeView: View {
    @State private var position: CGPoint = CGPoint(x: 0, y: 0)
    @State private var velocity: CGSize = CGSize(width: 4, height: 4)
    @State private var screenSize: CGSize = CGSize(width: 300, height: 600) // Default size

    @State private var clockViewSize: CGSize = CGSize.zero // Approximate text size for bounce logic
    let frameRate = 20.0 / 60.0 // 60 FPS
    let animationDuration = 1.00 // Control speed of animation
    
    
    @State private var now: Date
    @State private var isAnimating = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(now: Date) {
        self.now = now
    }
    
    private var hour: (String, String, Color?) {
        let hour = now.component(.hour)
        let normalizedHour = hour > 12 ? hour - 12 : hour
        
        let color: Color? = switch(viewMode) {
        case .active:
            .yellow.opacity(0.8)
        case .dim:
            nil
        }
        
        return (String(normalizedHour / 10), String(normalizedHour % 10), color)
    }
    
    private var minutes: (String, String) {
        (String(now.component(.minute) / 10), String(now.component(.minute) % 10))
    }
    
    private var seconds: (String, String) {
        (String(now.component(.second) / 10), String(now.component(.second) % 10))
    }
    
    private var viewMode: ViewMode {
        let hour = now.component(.hour)
        let minutes = now.component(.minute)
        
        return .active
        /**
         * Set full opacity if time >= 6:15 and < 8:00 am
         */
        return switch((hour, minutes)) {
        case (6, let mins) where mins >= 15, (7, let mins):
            .active
        default:
            .dim
        }
    }

    
    private func getSizeFromProxy(proxy: GeometryProxy) -> CGFloat {
        let TOTAL_COLS = 5.0
        
        return (proxy.size.width / TOTAL_COLS) - ((TOTAL_COLS - 1) * 2) - 32
    }
    
    var body: some View {
        // .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
        ZStack(alignment: .top) {
            
            VStack {
                
                GeometryReader { proxy in
                    let fullScreenSize = proxy.size
//                    Rectangle().fill(Color.yellow.opacity(viewMode == .active ? 0.8 : 0) ).frame(height: proxy.size.height * 0.05)
                    
                    if viewMode == .active {
                        Image(systemName: "sun.max")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: 200)
                                .font(.title)
                                .foregroundStyle(LinearGradient(
                                    colors: [.yellow, .red],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .position(position)
                                .offset(x: 0, y: -220)
//                                .offset(x: isAnimating ? 80 : -80, y: isAnimating ? -80 : 80)
                    }
                    
                            
                            
                    
                    Group {
                        HStack(spacing: 10) {
                            FlipClockNumberView(value: hour.0, size: getSizeFromProxy(proxy: proxy), color: hour.2, viewMode: viewMode)
                            FlipClockNumberView(value: hour.1, size: getSizeFromProxy(proxy: proxy), color: hour.2, viewMode: viewMode)
                            
                            FlipClockNumberView(value: ":", size: getSizeFromProxy(proxy: proxy), viewMode: viewMode)
                            
                            FlipClockNumberView(value: minutes.0, size: getSizeFromProxy(proxy: proxy), viewMode: viewMode)
                            FlipClockNumberView(value: minutes.1, size: getSizeFromProxy(proxy: proxy), viewMode: viewMode)
                        }
                    }
                    .background(GeometryReader { clockViewProxy in
                        Color.clear
                        .onAppear {
                            clockViewSize = clockViewProxy.size // Measure text size
                        }
                    })
//                    .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
                    .opacity(viewMode == .active ? 1 : 0.4)
//                    .offset(x: isAnimating ? 80 : -80, y: isAnimating ? -80 : 80)
                    .position(position)
                    .onReceive(timer) { input in
                        now = input
                        
                        let hour = now.component(.hour)
                        
                        // between 5pm and 8am, keep the timer from going to sleep
                        if hour >= 17 || hour < 8 {
                            UIApplication.shared.isIdleTimerDisabled = true
                        } else {
                            UIApplication.shared.isIdleTimerDisabled = false
                        }
                        
                        
                    }
                    .padding(16)
                    .onAppear {
                        // .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
                        position.x = proxy.frame(in: .local).midX
                        position.y = proxy.frame(in: .local).midY
                        screenSize = fullScreenSize // Set screen size initially
                        
                        Timer.scheduledTimer(withTimeInterval: frameRate, repeats: true) { _ in
                            withAnimation(.linear(duration: animationDuration)) {
                                moveClock()
                            }
                        }
                        
                       
                    }
                }
            }
            
            
        }
        .background(Color.black)
        .onAppear() {
            withAnimation(.easeIn(duration: 15).repeatForever()) {
                isAnimating = true
            }
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    func moveClock() {
        var newPos = position
        var newVelocity = velocity

        // Update position based on velocity
        newPos.x += newVelocity.width
        newPos.y += newVelocity.height

        // Bounce off the horizontal edges
        if newPos.x - clockViewSize.width / 2 <= 0 || newPos.x + clockViewSize.width / 2 >= screenSize.width {
            newVelocity.width = -newVelocity.width
        }

        // Bounce off the vertical edges
        if newPos.y - clockViewSize.height / 2 <= 0 || newPos.y + clockViewSize.height / 2 >= screenSize.height {
            newVelocity.height = -newVelocity.height
        }

        // Apply updates
        position = newPos
        velocity = newVelocity
    }
        
}

#Preview {
    let mockDate = DateComponents(calendar: Calendar.current, year: 2024, month: 9, day: 16, hour: 06, minute: 15).date!
    
    return HomeView(now: mockDate)
}
