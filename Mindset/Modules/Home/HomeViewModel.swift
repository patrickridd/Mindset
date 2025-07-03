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
    @Published var dayTime: DayTime
    
    private(set) var coordinator: any Coordinated
    private(set) var flowCoordinator: PromptChainFlowCoordinator?

    init(coordinator: any Coordinated, promptsEntryManager: PromptsEntryManager, dayTime: DayTime? = nil) {
        self.selectedDate = Calendar.current.startOfDay(for: Date())
        self.promptsEntryManager = promptsEntryManager
        self.coordinator = coordinator
        self.dayTime = dayTime ?? .morning

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

    private func presentPromptChainFlow() {
        guard let flowCoordinator, let entry else { return }
        presentingPromptChainFlow.toggle()
        SoundPlayer().entryStarted()
        coordinator.presentFullScreenCover(.promptsChainView(
            promptsEntry: entry,
            flowCoordinator: flowCoordinator,
            promptsEntryManager: promptsEntryManager
        ))
    }

    func journalCompleted() {
        if let entry {
            promptsEntryManager.save(entry: entry)
        }
        coordinator.dismissFullScreenOver()
        flowCoordinator?.reset()
    }

    func deleteButtonTapped() {
        if let entry {
            promptsEntryManager.delete(entry: entry)
        }
    }
}

