//
//  ViewHashable.swift
//  Mindset
//
//  Created by patrick ridd on 6/4/25.
//

import SwiftUI

enum CoordinatedView: Hashable, Identifiable {
    case homeView(promptsEntryManager: PromptsEntryManager, dayTime: DayTime)
    case trackerView(promptsEntryManager: PromptsEntryManager)
    case promptView(promptEntry: any PromptContent, flowCoordinator: PromptChainFlowCoordinator, promptsEntryManager: PromptsEntryManager)
    case promptsChainView(promptsEntry: PromptsEntry, flowCoordinator: PromptChainFlowCoordinator, promptsEntryManager: PromptsEntryManager)
    
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Conform to Equatable
    static func == (lhs: CoordinatedView, rhs: CoordinatedView) -> Bool {
        switch (lhs, rhs) {
        case (.promptView(promptEntry: let promptOne, _, _), .promptView(promptEntry: let promptTwo, _, _)):
            return promptOne.id == promptTwo.id
        case (.promptsChainView(let journalEntryOne, _, _), .promptsChainView(let journalEntryTwo, _, _)):
            return journalEntryOne.id == journalEntryTwo.id
        default:
            return true
        }
    }
}
