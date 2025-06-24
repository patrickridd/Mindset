//
//  EmojiProgress.swift
//  Mindset
//
//  Created by patrick ridd on 6/23/25.
//

import Foundation

enum ProgressEmoji: Int, CaseIterable {

    case one
    case two
    case three
    case four
    case five

    var emoji: String {
        switch self {
        case .one:
            return "🙂"
        case .two:
            return "😃"
        case .three:
            return "😄"
        case .four:
            return "😎"
        case .five:
            return "🤩"
        }
    }
}
