//
//  ViewHashable.swift
//  Mindset
//
//  Created by patrick ridd on 6/4/25.
//

import SwiftUI

enum CoordinatedView: Hashable, Identifiable {
    case homeView
    case promptView(journalPrompt: any PromptContent, flowCoordinator: PromptChainFlowCoordinator)
    case journalEntryView(journalEntry: PromptsEntry, flowCoordinator: PromptChainFlowCoordinator)
    
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Conform to Equatable
    static func == (lhs: CoordinatedView, rhs: CoordinatedView) -> Bool {
        switch (lhs, rhs) {
        case (.promptView(journalPrompt: let promptOne, _), .promptView(journalPrompt: let promptTwo, _)):
            return promptOne.id == promptTwo.id
        case (.journalEntryView(let journalEntryOne, _), .journalEntryView(let journalEntryTwo, _)):
            return journalEntryOne.id == journalEntryTwo.id
        default:
            return true
        }
    }
}
