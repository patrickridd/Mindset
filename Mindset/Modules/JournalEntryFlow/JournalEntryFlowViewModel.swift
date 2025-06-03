//
//  JournalEntryFlowViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

class JournalEntryFlowViewModel: ObservableObject {
    
    @Published var journalEntry: JournalEntryContent = JournalEntry(
        journalPrompts: [GratitudePrompt(), AffirmationPrompt(), ReflectionPrompt(), GoalPrompt()]
    )

    var journalPromptProgressValue: Double {
        let completedPromptsCount = Double(journalEntry.journalPrompts.filter({$0.completed}).count)
        return completedPromptsCount/Double(journalEntry.journalPrompts.count)
    }
}
