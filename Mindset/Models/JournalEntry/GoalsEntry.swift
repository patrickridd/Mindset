//
//  GoalsEntry.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import Foundation

struct GoalsEntry: JournalEntry {
    let title: String = "Goal for Today"
    let subtitle: String = "What would you like to get done today?"
    var entryText: String = ""
    var date: Date = Date()
}
