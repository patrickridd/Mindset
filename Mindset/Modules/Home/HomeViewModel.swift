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
    private(set) var journalEntry: PromptsEntry
    
    init(coordinator: any Coordinated) {
        self.coordinator = coordinator
        
        self.journalEntry = PromptsEntry(
            promptEntryDate: Date(),
            prompts: [.gratitude, Prompt.affirmation, .goalSetting],
            type: .day
        )
        self.flowCoordinator = PromptChainFlowCoordinator(
            steps: journalEntry.prompts,
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
