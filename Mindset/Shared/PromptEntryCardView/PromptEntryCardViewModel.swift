//
//  PromptEntryCardViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/28/25.
//

import Foundation

@MainActor
class PromptEntryCardViewModel: ObservableObject {

    let promptsEntryManager: PromptsEntryManager
    let entry: PromptsEntry
    let coordinator: any Coordinated

    init(
        entry: PromptsEntry,
        coordinator: any Coordinated,
        promptsEntryManager: PromptsEntryManager
    ) {
        self.entry = entry
        self.coordinator = coordinator
        self.promptsEntryManager = promptsEntryManager
    }

    func entryTapped() {
        let flowCoordinator = PromptChainFlowCoordinator(
            steps: entry.prompts,
            onCompletion: { [weak self] in
                guard let self else { return }
                self.coordinator.dismissFullScreenOver()
                self.promptsEntryManager.save(entry: self.entry)
            }
        )
        coordinator.presentFullScreenCover(.journalEntryView(
            journalEntry: entry,
            flowCoordinator: flowCoordinator
        ))
    }

    func deleteButtonTapped() {
        promptsEntryManager.delete(entry: entry)
    }
}
