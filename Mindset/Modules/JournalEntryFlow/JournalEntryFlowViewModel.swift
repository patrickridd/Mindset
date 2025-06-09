//
//  JournalEntryFlowViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

@MainActor
class JournalEntryFlowViewModel: ObservableObject {

    @Published var journalEntry: any JournalEntryContent
    private let parentCoordinator: any Coordinated

    var journalPrompts: [any Prompt] {
        journalEntry.journalPrompts
    }

    init(coordinator: any Coordinated, journalEntry: any JournalEntryContent) {
        self.parentCoordinator = coordinator
        self.journalEntry = journalEntry
    }

    var journalPromptProgressValue: Double {
        let completedPromptsCount = Double(journalPrompts.filter({$0.completed}).count)
        return completedPromptsCount/Double(journalPrompts.count)
    }

    func closeButtonTapped() {
        parentCoordinator.dismissFullScreenOver()
    }

}
