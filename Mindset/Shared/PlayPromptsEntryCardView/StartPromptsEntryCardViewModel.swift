//
//  StartPromptsEntryCardViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/29/25.
//

import Foundation
import SwiftUI

@MainActor
class StartPromptsEntryCardViewModel: ObservableObject {

    let coordinator: any Coordinated
    let promptsEntryManager: PromptsEntryManager
    let promptEntry = PromptsEntry(promptEntryDate: .today, prompts: [.gratitude, Prompt.affirmation, .goalSetting, Prompt.reflection], type: .morning)
    
    let dayTime: DayTime
    @Published var moodValue: Double = 3
    @Published var hasInteractedWithMoodSlider: Bool = false

    init(coordinator: any Coordinated, promptsEntryManager: PromptsEntryManager, dayTime: DayTime) {
        self.coordinator = coordinator
        self.promptsEntryManager = promptsEntryManager
        self.dayTime = dayTime
    }

    func playButtonTapped() {
        SoundPlayer().entryStarted()
        // TODO: Update PromptsEntryManager.createEntry to accept moodValue.
        let entry = promptsEntryManager.createEntry(for: .today, moodValue: self.moodValue, promptsEntryType: dayTime)
        let flowCoordinator = PromptChainFlowCoordinator(
            steps: entry.prompts,
            onCompletion: { [weak self] in
                guard let self else { return }
                self.coordinator.dismissFullScreenCover()
                self.promptsEntryManager.save(entry: entry)
            }
        )
        coordinator.presentFullScreenCover(.promptsChainView(
            promptsEntry: entry,
            flowCoordinator: flowCoordinator,
            promptsEntryManager: promptsEntryManager
        ))
    }

    var title: String {
        switch dayTime {
        case .morning:
            return "Good morning ☀️"
        case .night:
            return "Good Evening 🌝"
        }
    }
    
    func editButtonTapped() {
        print("editButtonTapped")
    }
}

