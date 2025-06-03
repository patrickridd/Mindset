//
//  JournalEntry.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import Foundation

protocol JournalEntryContent {
    var id: UUID { get set }
    var dateCompleted: Date? { get set }
    var journalPrompts: [JournalPrompt] { get set }
}

class JournalEntry: Identifiable, JournalEntryContent {
    var id: UUID = UUID()
    var dateCompleted: Date? = nil
    var journalPrompts: [JournalPrompt] = []
    
    init(id: UUID = UUID(), journalPrompts: [JournalPrompt]) {
        self.id = id
        self.journalPrompts = journalPrompts
    }
}
