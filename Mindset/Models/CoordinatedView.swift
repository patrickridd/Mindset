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
    case journalPromptView(journalPrompt: any Prompt, flowCoordinator: JournalEntryFlowCoordinator)
    case journalEntryView(journalEntry: JournalEntry, flowCoordinator: JournalEntryFlowCoordinator)
    
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Conform to Equatable
    static func == (lhs: CoordinatedView, rhs: CoordinatedView) -> Bool {
        switch (lhs, rhs) {
        case (.journalPromptView(journalPrompt: let promptOne, _), .journalPromptView(journalPrompt: let promptTwo, _)):
            return promptOne.id == promptTwo.id
        case (.journalEntryView(let journalEntryOne, _), .journalEntryView(let journalEntryTwo, _)):
            return journalEntryOne.id == journalEntryTwo.id
        default:
            return true
        }
    }
}
