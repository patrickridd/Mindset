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

    @Published var moodValue: Int?
    @Published var hasInteractedWithMoodSlider: Bool = false
    @Published var startButtonPlayed: Bool = false

    let promptsEntry: PromptsEntry
    let coordinator: any Coordinated
    let promptsEntryManager: PromptsEntryManager
    let dayTime: DayTime

    init(
        coordinator: any Coordinated,
        promptsEntryManager: PromptsEntryManager,
        dayTime: DayTime,
        selectedPrompts: [Prompt]?
    ) {
        self.coordinator = coordinator
        self.promptsEntryManager = promptsEntryManager
        self.dayTime = dayTime
        let prompts = selectedPrompts ?? dayTime.defaultPrompts
        self.promptsEntry = PromptsEntry(promptEntryDate: .today, prompts: prompts, type: dayTime)
    }

    func playButtonTapped() {
        startButtonPlayed.toggle()
        SoundPlayer().entryStarted()
        let flowCoordinator = PromptChainFlowCoordinator(
            steps: promptsEntry.prompts,
            onCompletion: { [weak self] in
                guard let self else { return }
                self.coordinator.dismissFullScreenCover()
                self.promptsEntryManager.save(entry: promptsEntry)
            }
        )
        coordinator.presentFullScreenCover(.promptsChainView(
            promptsEntry: promptsEntry,
            flowCoordinator: flowCoordinator,
            promptsEntryManager: promptsEntryManager
        ))
    }

    var title: String {
        switch dayTime {
        case .morning:
            return "Morning Mindset ☀️"
        case .night:
            return "Evening Reflection 🌝"
        }
    }
    
    var titleForegroundColor: Color {
        dayTime == .morning ? .orange : .indigo
    }
    
    func editButtonTapped() {
        print("editButtonTapped")
    }
}

