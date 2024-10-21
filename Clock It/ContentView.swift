//
//  ContentView.swift
//  Clock It
//
//  Created by Eric Masiello on 9/15/24.
//

import SwiftUI

struct ContentView: View {
    var now: Date
    var body: some View {
        HomeView(now: now)
            .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
    }
}

#Preview {
    let mockDate = DateComponents(calendar: Calendar.current, year: 2024, month: 9, day: 16, hour: 06, minute: 15).date!
    
    return ContentView(now: mockDate)
//    return ContentView(now: Date())
}
