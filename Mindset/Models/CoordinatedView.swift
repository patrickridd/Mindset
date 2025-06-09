//
//  ViewHashable.swift
//  Mindset
//
//  Created by patrick ridd on 6/4/25.
//

import SwiftUI

 
protocol CoordinatableView: View, Hashable, Identifiable {}

extension CoordinatableView {

    public var id: Self { self }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

enum CoordinatedView: Hashable, Identifiable {
    case homeView
    case journalPromptView(journalPrompt: any Prompt)
    case journalEntryView(journalEntry: JournalEntry)
    
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Conform to Equatable
    static func == (lhs: CoordinatedView, rhs: CoordinatedView) -> Bool {
        switch (lhs, rhs) {
        case (.journalPromptView(journalPrompt: let promptOne), .journalPromptView(journalPrompt: let promptTwo)):
            return promptOne.id == promptTwo.id
        case (.journalEntryView(let journalEntryOne), .journalEntryView(let journalEntryTwo)):
            return journalEntryOne.id == journalEntryTwo.id
        default:
            return true
        }
    }
}
