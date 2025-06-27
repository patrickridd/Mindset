//
//  HomeViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/26/25.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var presentingPromptChainFlow: Bool = false
    @Published var selectedDate: Date
    @Published var journalEntries: [Date: PromptsEntry] = [:]
    @Published var journalEntry: PromptsEntry?

    private let coordinator: any Coordinated
    private let promptsEntryPersistence: PromptsEntryPersistence
    private(set) var flowCoordinator: PromptChainFlowCoordinator?
    
    init(coordinator: any Coordinated, promptsEntryPersistence: PromptsEntryPersistence) {
        self.selectedDate = Calendar.current.startOfDay(for: Date())
        self.promptsEntryPersistence = promptsEntryPersistence
        self.coordinator = coordinator
        self.loadJournalEntries()
        self.journalEntry = entry(for: selectedDate)

        if let journalEntry {
            self.flowCoordinator = PromptChainFlowCoordinator(
                steps: journalEntry.prompts,
                onCompletion: { [weak self] in
                    self?.journalCompleted()
                })
        }
    }

    func loadJournalEntries() {
        let entries = promptsEntryPersistence.load()
        for entry in entries {
            journalEntries[Calendar.current.startOfDay(for: entry.promptEntryDate)] = entry
        }
    }

    func journalButtonTapped() {
        guard let flowCoordinator, let journalEntry else {
            createNewPromptEntry()
            journalButtonTapped()
            return
        }
        presentingPromptChainFlow.toggle()
        SoundPlayer().entryStarted()
        coordinator.presentFullScreenCover(.journalEntryView(
            journalEntry: journalEntry,
            flowCoordinator: flowCoordinator
        ))
    }

    func journalCompleted() {
        if let journalEntry {
            promptsEntryPersistence.save([journalEntry])
            journalEntries[selectedDate] = journalEntry
        }
        self.journalEntry = journalEntry
        coordinator.dismissFullScreenOver()
        flowCoordinator?.reset()
    }

    func entry(for date: Date) -> PromptsEntry? {
        journalEntries[date.startOfDay]
    }

    func deleteEntry() {
        guard
            let journalEntry,
            let index = journalEntries.values.firstIndex(of: journalEntry)
        else {
            self.journalEntry = nil
            return
        }
        journalEntries.remove(at: index)
        promptsEntryPersistence.delete(journalEntry)
        self.journalEntry = nil
    }

    private func createNewPromptEntry() {
        let newEntry = PromptsEntry(
            promptEntryDate: selectedDate.startOfDay,
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
