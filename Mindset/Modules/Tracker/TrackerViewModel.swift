//
//  ChartViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import Combine
import SwiftUI

@MainActor
class TrackerViewModel: ObservableObject {

    @Published var selectedDate: Date
    @Published var entryDisplayed: PromptsEntry?
    @Published var presentingPromptChainFlow: Bool = false

    private let coordinator: any Coordinated
    private let promptsEntryManager: PromptsEntryManager
    private var cancellable: AnyCancellable?
    private(set) var flowCoordinator: PromptChainFlowCoordinator?

    var buttonDisabled: Bool {
        !Calendar.current.isDate(selectedDate, inSameDayAs: Date())
    }

    init(coordinator: any Coordinated, promptsEntryManager: PromptsEntryManager) {
        self.selectedDate = Calendar.current.startOfDay(for: Date())
        self.promptsEntryManager = promptsEntryManager
        self.coordinator = coordinator
        self.entryDisplayed = promptsEntryManager.promptEntry(for: selectedDate)

        if let entryDisplayed {
            self.flowCoordinator = PromptChainFlowCoordinator(
                steps: entryDisplayed.prompts,
                onCompletion: { [weak self] in
                    self?.journalCompleted()
                })
        }
        self.addSelectedDateSubscriber()
    }

    func journalButtonTapped() {
        guard let flowCoordinator, let entryDisplayed else {
            createNewPromptEntry()
            journalButtonTapped()
            return
        }
        presentingPromptChainFlow.toggle()
        SoundPlayer().entryStarted()
        coordinator.presentFullScreenCover(.journalEntryView(
            journalEntry: entryDisplayed,
            flowCoordinator: flowCoordinator
        ))
    }

    func journalCompleted() {
        if let entryDisplayed {
            promptsEntryManager.save(entry: entryDisplayed,
                                     selectedDate: entryDisplayed.promptEntryDate)
        }
        coordinator.dismissFullScreenOver()
        flowCoordinator?.reset()
    }

    func addSelectedDateSubscriber() {
        cancellable = $selectedDate.sink(receiveValue: { [weak self] newDate in
            self?.entryDisplayed = self?.promptsEntryManager.promptEntry(for: newDate.startOfDay)
        })
    }
    
    func deleteButtonTapped() {
        if let entryDisplayed {
            promptsEntryManager.delete(entry: entryDisplayed)
        }
        entryDisplayed = nil
    }

    private func createNewPromptEntry() {
        let entry = promptsEntryManager.createEntry(for: selectedDate)
        self.flowCoordinator = PromptChainFlowCoordinator(
            steps: entry.prompts,
            onCompletion: { [weak self] in
                self?.journalCompleted()
            }
        )
    }
}
