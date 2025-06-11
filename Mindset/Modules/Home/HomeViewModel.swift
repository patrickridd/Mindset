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

    init(coordinator: any Coordinated) {
        self.coordinator = coordinator
    }

    func journalButtonTapped() {
        coordinator.presentFullScreenCover(.journalEntryView(
            journalEntry: JournalEntry(
                journalPrompts: [.gratitude, JournalPrompt.affirmation, .goalSetting]
            ),
            flowCoordinator: JournalEntryFlowCoordinator(
                steps: [.gratitude, JournalPrompt.affirmation, .goalSetting],
                onCompletion: { [weak self] in
                    self?.coordinator.dismissFullScreenOver()
            })
        ))
    }

}
