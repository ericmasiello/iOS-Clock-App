//
//  File.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/21/24.
//

import SwiftUI

extension Date {
  func component(_ component: Calendar.Component) -> Int {
    let calendar = Calendar.current
    let result = calendar.component(component, from: self)
    return result
  }
}
