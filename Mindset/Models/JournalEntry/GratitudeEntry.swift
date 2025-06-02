//
//  GratitudeEntry.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import Foundation

struct GratitudeEntry: JournalEntry {
    let title: String = "Gratitude"
    let subtitle: String = "What are you grateful for today?"
    var date: Date
    var entryText: String
    
    init(date: Date = Date(), entryText: String = "") {
        self.date = date
        self.entryText = entryText
    }
}
