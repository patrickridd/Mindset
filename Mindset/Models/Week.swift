//
//  Week.swift
//  Mindset
//
//  Created by patrick ridd on 5/14/25.
//

import Foundation

enum Week: Int, CaseIterable, Identifiable {
    var id: Int {
        self.rawValue
    }

    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var abbreviation: String {
        switch self {
        case .sunday, .saturday:
            return "S"
        case .monday:
            return "M"
        case .tuesday, .thursday:
            return "T"
        case .wednesday:
            return "W"
        case .friday:
            return "F"
        }
    }
    
}
