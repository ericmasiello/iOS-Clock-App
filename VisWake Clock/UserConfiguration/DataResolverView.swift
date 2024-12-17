//
//  DataResolverView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 12/16/24.
//

import SwiftUI
import SwiftData

struct DataResolverView: View {
  @Environment(\.modelContext) var modelContext
  @Query(sort: \UserConfiguration.wakeupTime) var userConfigurations: [UserConfiguration]
  
  var body: some View {
    Group {
      if let userConfig = userConfigurations.first {
        ContentView(userConfig: userConfig)
      } else {
        LoadingView()
      }
    }
    .preferredColorScheme(.dark)
    .onAppear {
      guard userConfigurations.count == 0 else {
        // only need 1 configuration defined
        return
      }

      // initialize with some defaults if not yet set
      let config = UserConfiguration(
        wakeupTime: UserConfiguration.createWakeTime(hour: 6, minutes: 15))
      modelContext.insert(config)
    }
  }
}

#Preview {
  do {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: UserConfiguration.self, configurations: config)
    
    let userConfig = UserConfiguration(wakeupTime: UserConfiguration.createWakeTime(hour: 6, minutes: 20))
    
    container.mainContext.insert(userConfig)
    
    return DataResolverView()
      .modelContainer(container)
      .preferredColorScheme(.dark)
      
  } catch {
    return Text("Failed to create container \(error.localizedDescription)")
  }
}
