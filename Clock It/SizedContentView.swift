//
//  SizedContentView.swift
//  Clock It
//
//  Created by Eric Masiello on 10/31/24.
//

import SwiftUI

struct SizedContentView: View {
    var viewMode: ViewMode
    var temperatureF: Float
    var now: Date
    
    private var size: CGFloat {
        let denominator = 5.0
        let fudge = (((denominator - 1) * 2) * -1) - 32
        let size = (UIScreen.main.bounds.width / denominator) + fudge
        return size
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewMode == .active {
                EmojiView(option: .sparkles, size: size)
            }
            ClockView(size: size, viewMode: viewMode, now: now)
            HStack {
                Spacer()
                TemperatureView(temperatureF: temperatureF)
            }
        }
        // constrains it to widest element
        .fixedSize()
    }
}

#Preview("Active") {
    SizedContentView(viewMode: .active, temperatureF: 54.2, now: Date())
    .preferredColorScheme(.dark)
}


#Preview("Dim") {
        SizedContentView(viewMode: .dim, temperatureF: 54.2, now: Date())
    .preferredColorScheme(.dark)
}
