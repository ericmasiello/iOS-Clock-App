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
    @State private var currentTemperatureInF: Float? = nil

    @State private var clockViewSize: CGSize = CGSize.zero // Approximate text size for bounce logic
    @State private var temperatureViewSize: CGSize = CGSize.zero // Approximate text size for bounce logic
    let frameRate = 20.0 / 60.0 // 60 FPS
    let animationDuration = 1.00 // Control speed of animation
    
    
    @State private var now: Date
    @State private var isAnimating = false
    private let clockTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // fetch every 3 hours
    private let fetchWeatherTimer = Timer.publish(every: 60*60*3, on: .main, in: .common).autoconnect()
    
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
        
        // return .active
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
            
            VStack(alignment: .center) {
                
                
                GeometryReader { proxy in
                    let fullScreenSize = proxy.size
                    let size =  getSizeFromProxy(proxy: proxy);

                    if let temp = currentTemperatureInF {
                        Text("\(Int(temp.rounded()))℉")
                            .font(.largeTitle)
                            .monospaced()
                            .foregroundColor(.white)
                            .background(GeometryReader { temperatureProxy in
                                Color.clear
                                .onAppear {
                                    temperatureViewSize = temperatureProxy.size // Measure text size
                                }
                            })
                            .position(position)
                            .offset(x: (clockViewSize.width / 2) - (temperatureViewSize.width / 2), y: clockViewSize.height - temperatureViewSize.height)
                            
                    }
                    
                    if viewMode == .active {
                        // TODO: make this dynamic - it can be based on the current weather
                        // or we can allow customers set a custom emoji for a specific day
                        Text("🌈✨🦄")
                            .font(.system(size: size * 0.95))
                            .foregroundStyle(LinearGradient(
                                colors: [.yellow, .red],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            .position(position)
                            .offset(x: 0, y: clockViewSize.height * -1)
                    }
                    
                    Group {
                        
                        HStack(spacing: 10) {
                            FlipClockNumberView(value: hour.0, size: size, color: hour.2, viewMode: viewMode)
                            FlipClockNumberView(value: hour.1, size: size, color: hour.2, viewMode: viewMode)
                            
                            FlipClockNumberView(value: ":", size: size, viewMode: viewMode)
                            
                            FlipClockNumberView(value: minutes.0, size: size, viewMode: viewMode)
                            FlipClockNumberView(value: minutes.1, size: size, viewMode: viewMode)
                        }
                    }
                    .background(GeometryReader { clockViewProxy in
                        Color.clear
                        // TODO: change to Color.clear
                        // Color.red.opacity(0.2)
                        .onAppear {
                            clockViewSize = clockViewProxy.size // Measure text size
                        }
                    })
//                    .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
                    .opacity(viewMode == .active ? 1 : 0.4)
//                    .offset(x: isAnimating ? 80 : -80, y: isAnimating ? -80 : 80)
                    .position(position)
                    .onReceive(clockTimer) { input in
                        now = input
                        
                        let hour = now.component(.hour)
                        
                        // between 5pm and 8am, keep the timer from going to sleep
                        if hour >= 17 || hour < 8 {
                            UIApplication.shared.isIdleTimerDisabled = true
                        } else {
                            UIApplication.shared.isIdleTimerDisabled = false
                        }
                        
                        
                    }
                    .onReceive(fetchWeatherTimer) { input in
                        print("Fetch the weather")
                        print(input)
                        
                        
                    }
                    .padding(16)
                    .onAppear {
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
//            .border(Color.red)
            
            
        }
        .background(Color.black)
        .onAppear() {
            withAnimation(.easeIn(duration: 15).repeatForever()) {
                isAnimating = true
            }
            UIApplication.shared.isIdleTimerDisabled = true
            
            Task {
                let data = await WeatherClient.getWeather()
                
                guard let data = data else {
                    return
                }
                
                currentTemperatureInF = data.current.temperature2m
                
                /// Timezone `.gmt` is deliberately used.
                /// By adding `utcOffsetSeconds` before, local-time is inferred
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = .gmt
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                for (i, date) in data.daily.time.enumerated() {
                    print(dateFormatter.string(from: date))
                    print(data.daily.weatherCode[i])
                    print(data.daily.temperature2mMax[i])
                    print(data.daily.temperature2mMin[i])
                    print(data.daily.apparentTemperatureMax[i])
                    print(data.daily.apparentTemperatureMin[i])
                    print(data.daily.precipitationSum[i])
                    print(data.daily.rainSum[i])
                    print(data.daily.showersSum[i])
                    print(data.daily.snowfallSum[i])
                    print(data.daily.precipitationHours[i])
                    print(data.daily.precipitationProbabilityMax[i])
                    print(data.daily.windSpeed10mMax[i])
                    print(data.daily.windGusts10mMax[i])
                }

            }
            
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
