//
//  DaysUntilView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 12/17/24.
//

import SwiftUI

enum EventErrorKind: Error {
  case invalidDate(String, Date)
  case invalidDateRange(String, Date, Date)
}

public struct DaysUntilView: View {
  var events: [CountdownEvent]
  var referenceDate: Date = Date()
  
  var nextEvent: CountdownEvent? {
    
    events
    // sort events by date
      .sorted { $0.date < $1.date }
    // grab the next one that happens after today
      .first { $0.date >= referenceDate }
  }
  
  private func normalizeDate(_ date: Date) -> Date? {
    var dateComponents = Calendar.current.dateComponents([.day], from: date)
    dateComponents.hour = 0
    dateComponents.minute = 0
    dateComponents.second = 0
    
    return Calendar.current.date(from: dateComponents)
  }
  
  func daysUntilEvent(_ event: CountdownEvent) throws -> Int {
    guard let eventDate = normalizeDate(event.date) else {
      throw EventErrorKind.invalidDate("Invalid event date", event.date)
    }
    guard let referenceDate = normalizeDate(referenceDate) else {
      throw EventErrorKind.invalidDate("Invalid reference date", referenceDate)
    }
    
    guard let result = Calendar.current.dateComponents([.day], from: referenceDate, to: eventDate).day else {
      throw EventErrorKind.invalidDateRange("Invalid days until", referenceDate, eventDate)
    }
    
    return result
  }
  
  public var body: some View {
    if let event = nextEvent, let days = try? daysUntilEvent(event) {
      Text("\(days) days until \(event.name)")      
    } else {
      EmptyView()
    }
  }
}

#Preview {
  
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy/MM/dd HH:mm"
  let referenceDate = formatter.date(from: "2024/12/17 21:59")!
  
  // create a date for 12/31/2024
  let christmasDate = formatter.date(from: "2024/12/25 21:38")!
  
  let nyeDate = formatter.date(from: "2024/12/31 00:01")!
  
  
  let events: [CountdownEvent] = [
    CountdownEvent(date: nyeDate, name: "NYE"),
    CountdownEvent(date: christmasDate, name: "Christmas"),
  ]
  
  return DaysUntilView(events: events, referenceDate: referenceDate)
}
