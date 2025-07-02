//
//  StartPromptsEntryCardViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/29/25.
//

import Foundation

@MainActor
class StartPromptsEntryCardViewModel: ObservableObject {

    let coordinator: any Coordinated
    let promptsEntryManager: PromptsEntryManager
    let promptEntry = PromptsEntry(promptEntryDate: .today, prompts: [.gratitude, Prompt.affirmation, .goalSetting, Prompt.reflection], type: .day)

    init(coordinator: any Coordinated, promptsEntryManager: PromptsEntryManager) {
        self.coordinator = coordinator
        self.promptsEntryManager = promptsEntryManager
    }

    func playButtonTapped() {
        SoundPlayer().entryStarted()
        let entry = promptsEntryManager.createEntry(for: .today)
        let flowCoordinator = PromptChainFlowCoordinator(
            steps: entry.prompts,
            onCompletion: { [weak self] in
                guard let self else { return }
                self.coordinator.dismissFullScreenOver()
                self.promptsEntryManager.save(entry: entry)
            }
        )
        coordinator.presentFullScreenCover(.promptsChainView(
            promptsEntry: entry,
            flowCoordinator: flowCoordinator,
            promptsEntryManager: promptsEntryManager
        ))
    }

    func editButtonTapped() {
        print("editButtonTapped")
    }
}
