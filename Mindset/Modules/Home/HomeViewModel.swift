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

    @Published var presentingPromptChainFlow: Bool = false
    @Published var selectedDate: Date
    @Published var journalEntries: [Date: PromptsEntry] = [:]
    @Published var journalEntry: PromptsEntry?

    private let coordinator: any Coordinated
    private let promptsEntryPersistence: PromptsEntryPersistence
    private var cancellable: AnyCancellable?
    private(set) var flowCoordinator: PromptChainFlowCoordinator?

    var buttonDisabled: Bool {
        !Calendar.current.isDate(selectedDate, inSameDayAs: Date())
    }

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
        coordinator.dismissFullScreenOver()
        flowCoordinator?.reset()
    }

    func entry(for date: Date) -> PromptsEntry? {
        journalEntries[date.startOfDay]
    }

    func addSelectedDateSubscriber() {
        cancellable = $selectedDate.sink(receiveValue: { [weak self] newDate in
            self?.journalEntry = self?.entry(for: newDate)
        })
    }

    func deleteEntry() {
        guard
            let journalEntry,
            let index = journalEntries.values.firstIndex(of: journalEntry)
        else { return }
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
