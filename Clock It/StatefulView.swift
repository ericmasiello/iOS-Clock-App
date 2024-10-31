//
//  PrimaryView.swift
//  Clock It
//
//  Created by Eric Masiello on 10/31/24.
//

import SwiftUI

struct StatefulView: View {
    @State private var now = Date()
    private let clockTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var currentTemperatureInF: Float = 0.0
    
    private var viewMode: ViewMode {
        let hour = now.component(.hour)
        let minutes = now.component(.minute)
        
//         return .active
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
    
    var body: some View {
        BounceView {
            SizedContentView(viewMode: viewMode, temperatureF: currentTemperatureInF, now: now)
        }
        .onReceive(clockTimer) { input in
            now = input
        }
        .onAppear {
            Task {
                let data = await WeatherClient.getWeather()
                
                guard let data = data else {
                    return
                }
                
                currentTemperatureInF = data.current.temperature2m
            }
        }
    }
}

#Preview {
    StatefulView().preferredColorScheme(.dark)
}
