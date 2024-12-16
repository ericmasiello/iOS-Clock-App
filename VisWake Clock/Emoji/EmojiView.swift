//
//  EmojiView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/31/24.
//

import SwiftUI

enum EmojiOption {
  case sparkles
  case halloween
  case thanksgiving
  case snow
  case sunshine
  case windy
  case rain
}

struct EmojiView: View {
  var option: EmojiOption
  var size: CGFloat

  private var emoji: String {
    switch option {
    case .sparkles:
      return "🌈✨🦄"
    case .halloween:
      return "🍂🎃👻"
    case .thanksgiving:
      return "🍂🦃🌽"
    case .snow:
      return "☃️🏂❄️"
    case .sunshine:
      return "☀️🌳🌸"
    case .windy:
      return "💨🧥☁️"
    case .rain:
      return "☔️🌧️🌈"
    }
  }

  var body: some View {
    Text(emoji)
      .font(.system(size: size * 0.95))
  }
}

#Preview {
  let size = CGFloat(40)
  List {
    EmojiView(option: .sparkles, size: size)
    EmojiView(option: .halloween, size: size)
    EmojiView(option: .thanksgiving, size: size)
    EmojiView(option: .snow, size: size)
    EmojiView(option: .sunshine, size: size)
    EmojiView(option: .windy, size: size)
    EmojiView(option: .rain, size: size)
  }
  .preferredColorScheme(.dark)
}
