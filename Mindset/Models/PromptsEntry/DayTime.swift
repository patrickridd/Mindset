//
//  PromptsEntryTime.swift
//  Mindset
//
//  Created by patrick ridd on 6/24/25.
//

import Foundation

enum DayTime: String, Codable, CaseIterable {
    case morning
    case night
    
    var defaultPrompts: [Prompt]  {
        switch self {
        case .morning:
            return [.gratitude, .gratitude, .gratitude, .affirmation]
        case .night:
            return [.reflection, .goalSetting, .selfTalk]

        }
    }
}
