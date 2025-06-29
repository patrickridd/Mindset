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
    @Published var promptsEntryManager: PromptsEntryManager

    private(set) var coordinator: any Coordinated
    private(set) var flowCoordinator: PromptChainFlowCoordinator?

    init(coordinator: any Coordinated, promptsEntryManager: PromptsEntryManager) {
        self.selectedDate = Calendar.current.startOfDay(for: Date())
        self.promptsEntryManager = promptsEntryManager
        self.coordinator = coordinator

        if let entry {
            self.flowCoordinator = PromptChainFlowCoordinator(
                steps: entry.prompts,
                onCompletion: { [weak self] in
                    self?.journalCompleted()
                })
        }
    }

    var entry: PromptsEntry? {
        promptsEntryManager.promptEntry(for: selectedDate)
    }

    func journalButtonTapped() {
        guard entry != nil else {
            createNewPromptEntry()
            presentPromptChainFlow()
            return
        }
        presentPromptChainFlow()
    }

    private func presentPromptChainFlow() {
        guard let flowCoordinator, let entry else { return }
        presentingPromptChainFlow.toggle()
        SoundPlayer().entryStarted()
        coordinator.presentFullScreenCover(.journalEntryView(
            journalEntry: entry,
            flowCoordinator: flowCoordinator
        ))
    }

    func journalCompleted() {
        if let entry {
            promptsEntryManager.save(entry: entry, selectedDate: entry.promptEntryDate)
        }
        coordinator.dismissFullScreenOver()
        flowCoordinator?.reset()
    }

    func deleteButtonTapped() {
        if let entry {
            promptsEntryManager.delete(entry: entry)
        }
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
