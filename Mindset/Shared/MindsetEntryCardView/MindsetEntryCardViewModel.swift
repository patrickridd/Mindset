//
//  StartPromptsEntryCardViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/29/25.
//

import SwiftUI

@MainActor
class MindsetEntryCardViewModel: ObservableObject {

    @Published var hasInteractedWithMoodSlider: Bool = false
    @Published var startButtonPlayed: Bool = false
    @Published var error: Bool = false
    private(set) var promptsEntry: PromptsEntry
    
    let coordinator: any Coordinated
    let promptsEntryManager: PromptsEntryManager
    let dayTime: DayTime
    let progressStatus: ProgressStatus
    var onDelete: (() -> Void)? // Add this property

    init(
        coordinator: any Coordinated,
        promptsEntryManager: PromptsEntryManager,
        dayTime: DayTime,
        promptsEntry: PromptsEntry,
        progressStatus: ProgressStatus,
        onDelete: (() -> Void)?
    ) {
        self.coordinator = coordinator
        self.promptsEntryManager = promptsEntryManager
        self.dayTime = dayTime
        self.promptsEntry = promptsEntry
        self.progressStatus = progressStatus
        self.onDelete = onDelete
    }

    func playButtonTapped() {
        if progressStatus == .locked {
            error.toggle()
            return
        }
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
    
    var buttonImage: Image {
        switch progressStatus {
        case .locked:
            return Image(systemName: "lock.circle.fill")
        case .inProgress, .completed:
            return Image(systemName: "square.and.pencil.circle.fill")
        }
    }

    var buttonForegroundColor: Color {
        switch progressStatus {
        case .inProgress:
            return .white
        case .locked:
            return .white
        case .completed:
            return .white
        }
    }

    var buttonBackgroundColor: Color {
        switch progressStatus {
        case .inProgress:
            return .clear
        case .locked:
            return .gray
        case .completed:
            return .white
        }
    }

    var backgroundColor: LinearGradient {
        switch dayTime {
        case .morning:
            LinearGradient(colors: [Color.orange, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing)        case .night:
            LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    var sensoryFeedback: SensoryFeedback {
        switch progressStatus {
        case .locked:
            return .error
        case .inProgress, .completed:
            return .selection
        }
    }

    var sensoryFeedbackTrigger: Bool {
        switch progressStatus {
        case .locked:
            return error
        case .inProgress, .completed:
            return startButtonPlayed
        }
    }

    var rewindColor: Color {
        switch dayTime {
        case .morning:
            return .white
        case .night:
            return .white
        }
    }
    
    func resetButtonTapped() {
        promptsEntryManager.delete(entry: promptsEntry)
        onDelete?() // Call the closure after deletion
    }
}

