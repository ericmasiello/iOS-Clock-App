//
//  ContentView.swift
//  Clock It
//
//  Created by Eric Masiello on 9/15/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        StatefulView()
            .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
