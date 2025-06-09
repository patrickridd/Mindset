//
//  JournalEntry.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import Foundation

protocol JournalEntryContent: Identifiable {
    var id: UUID { get set }
    var dateCompleted: Date? { get set }
    var journalPrompts: [any Prompt] { get set }
}

class JournalEntry: JournalEntryContent {
    var id: UUID = UUID()
    var dateCompleted: Date? = nil
    var journalPrompts: [any Prompt] = []
    
    init(id: UUID = UUID(), journalPrompts: [any Prompt]) {
        self.id = id
        self.journalPrompts = journalPrompts
    }
}
