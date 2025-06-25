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
    
    private(set) var flowCoordinator: PromptChainFlowCoordinator?
    private(set) var journalEntry: JournalEntry
    
    init(coordinator: any Coordinated) {
        self.coordinator = coordinator
        
        self.journalEntry = JournalEntry(
            journalPrompts: [.gratitude, JournalPrompt.affirmation, .goalSetting]
        )
        self.flowCoordinator = PromptChainFlowCoordinator(
            steps: journalEntry.journalPrompts,
            onCompletion: { [weak self] in
                self?.journalCompleted()
        })

    }

    func journalButtonTapped() {
        guard let flowCoordinator else { return }
        presentJournalEntry.toggle()
        SoundPlayer().entryStarted()
        coordinator.presentFullScreenCover(.journalEntryView(
            journalEntry: journalEntry,
            flowCoordinator: flowCoordinator
        ))
    }

    func journalCompleted() {
        coordinator.dismissFullScreenOver()
        flowCoordinator?.reset()
    }
}
