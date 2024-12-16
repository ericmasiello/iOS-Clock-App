//
//  EmojiManager.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 11/1/24.
//

import Foundation

class EmojiManager {
  static func option(by now: Date) -> EmojiOption {
    let month = now.component(.month)

    if month == 10 {
      return .halloween
    } else if month == 11 {
      return .thanksgiving
    } else if month == 12 {
      return .snow
    }
    return .sparkles
  }
}
