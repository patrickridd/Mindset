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
    @Published var selectedDate: Date
    @Published var journalEntries: [Date: PromptsEntry] = [:]

    private let coordinator: any Coordinated

    private(set) var flowCoordinator: PromptChainFlowCoordinator?
    private(set) var journalEntry: PromptsEntry?

    init(coordinator: any Coordinated) {
        self.selectedDate = Calendar.current.startOfDay(for: Date())
        self.coordinator = coordinator
        self.journalEntry = entryForSelectedDate
        if let journalEntry {
            self.flowCoordinator = PromptChainFlowCoordinator(
                steps: journalEntry.prompts,
                onCompletion: { [weak self] in
                    self?.journalCompleted()
                })
        }
    }

    func journalButtonTapped() {
        guard let flowCoordinator, let journalEntry else {
            createNewPromptEntry()
            journalButtonTapped()
            return
        }
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
        journalEntries[selectedDate] = journalEntry
    }

    var entryForSelectedDate: PromptsEntry? {
        journalEntries[selectedDate]
    }
    
    func selectDate(_ date: Date) {
        self.selectedDate = date
    }

    private func createNewPromptEntry() {
        let newEntry = PromptsEntry(
            promptEntryDate: selectedDate,
            prompts: [.gratitude, Prompt.affirmation, .goalSetting],
            type: .day
        )
        self.journalEntry = newEntry
        self.flowCoordinator = PromptChainFlowCoordinator(
            steps: newEntry.prompts,
            onCompletion: { [weak self] in
                self?.journalCompleted()
        })
    }
}
