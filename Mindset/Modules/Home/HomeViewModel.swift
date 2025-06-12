//
//  HomeViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {

    @Published var presentJournalEntry: Bool = false
    private let coordinator: any Coordinated
    
    private(set) var flowCoordinator: JournalEntryFlowCoordinator
    private(set) var journalEntry: JournalEntry
    
    init(coordinator: any Coordinated) {
        self.coordinator = coordinator
        
        self.journalEntry = JournalEntry(
            journalPrompts: [.gratitude, JournalPrompt.affirmation, .goalSetting]
        )
        self.flowCoordinator = JournalEntryFlowCoordinator(
            steps: journalEntry.journalPrompts,
            onCompletion: {
        })
        
        self.flowCoordinator.onCompletion = { [weak self] in
            coordinator.dismissFullScreenOver()
            self?.flowCoordinator.popToRoot()
        }

    }

    func journalButtonTapped() {
        presentJournalEntry.toggle()
        coordinator.presentFullScreenCover(.journalEntryView(
            journalEntry: journalEntry,
            flowCoordinator: flowCoordinator
        ))
    }

}
