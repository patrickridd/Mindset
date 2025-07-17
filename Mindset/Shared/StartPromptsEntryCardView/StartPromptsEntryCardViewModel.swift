//
//  StartPromptsEntryCardViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/29/25.
//

import SwiftUI

@MainActor
class StartPromptsEntryCardViewModel: ObservableObject {

    @Published var moodValue: Int?
    @Published var hasInteractedWithMoodSlider: Bool = false
    @Published var startButtonPlayed: Bool = false

    private(set) var promptsEntry: PromptsEntry
    
    let coordinator: any Coordinated
    let promptsEntryManager: PromptsEntryManager
    let dayTime: DayTime

    init(
        coordinator: any Coordinated,
        promptsEntryManager: PromptsEntryManager,
        dayTime: DayTime,
        promptsEntry: PromptsEntry
    ) {
        self.coordinator = coordinator
        self.promptsEntryManager = promptsEntryManager
        self.dayTime = dayTime
        self.promptsEntry = promptsEntry
    }

    func playButtonTapped() {
        startButtonPlayed.toggle()
        SoundPlayer().entryStarted()
        let flowCoordinator = PromptChainFlowCoordinator(
            steps: promptsEntry.prompts,
            onCompletion: { [weak self] in
                guard let self else { return }
                self.coordinator.dismissFullScreenCover()
                self.promptsEntry.setEntryCompleted()
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
        dayTime == .morning ? .white : .white
    }
    
    func editButtonTapped() {
        print("editButtonTapped")
    }

    var backgroundColor: LinearGradient {
        switch dayTime {
        case .morning:
            LinearGradient(colors: [Color.orange, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing)        case .night:
            LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

