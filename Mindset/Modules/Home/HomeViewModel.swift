//
//  HomeViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import Combine
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {

    @Published var presentJournalEntry: Bool = false
    @Published var selectedDate: Date
    @Published var journalEntries: [Date: PromptsEntry] = [:]
    
    private let coordinator: any Coordinated
    private let promptsEntryPersistence: PromptsEntryPersistence
    private(set) var flowCoordinator: PromptChainFlowCoordinator?
    private(set) var journalEntry: PromptsEntry?
    private var cancellable: AnyCancellable?

    init(coordinator: any Coordinated, promptsEntryPersistence: PromptsEntryPersistence) {
        self.selectedDate = Calendar.current.startOfDay(for: Date())
        self.promptsEntryPersistence = promptsEntryPersistence
        self.coordinator = coordinator
        self.loadJournalEntries()
        self.journalEntry = entryForSelectedDate
        if let journalEntry {
            self.flowCoordinator = PromptChainFlowCoordinator(
                steps: journalEntry.prompts,
                onCompletion: { [weak self] in
                    self?.journalCompleted()
                })
        }
        self.addSelectedDateSubscriber()
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
        presentJournalEntry.toggle()
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
        coordinator.dismissFullScreenOver()
        flowCoordinator?.reset()
    }

    var entryForSelectedDate: PromptsEntry? {
        journalEntries[selectedDate]
    }
    
    func addSelectedDateSubscriber() {
        cancellable = $selectedDate.sink(receiveValue: { [weak self] _ in
            self?.loadJournalEntries()
            self?.journalEntry = self?.entryForSelectedDate
        })
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
