//
//  DateTimeProvider.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 11/1/24.
//
import Combine
import Foundation

class DateTimeManager: ObservableObject {
  // A published property that will update every second
  @Published var now = Date()

  private var cancellable: AnyCancellable?

  init() {
    // Use Timer.publish to create a timer that emits every 1 second
    self.cancellable = Timer.publish(every: 1.0, on: .main, in: .default)
      .autoconnect()  // Automatically connect to start receiving updates
      .sink { [weak self] current in
        self?.now = current
      }
  }

  deinit {
    cancellable?.cancel()
  }
}
