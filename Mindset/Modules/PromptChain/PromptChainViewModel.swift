//
//  PromptChainViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import Combine
import SwiftUI

@MainActor
class PromptChainViewModel: ObservableObject {

    @Published var promptsEntry: PromptsEntry
    let parentCoordinator: any Coordinated
    private let flowCoordinator: PromptChainFlowCoordinator
    private let promptsEntryManager: PromptsEntryManager
    private(set) var cancellable: Cancellable?

    var prompts: [any PromptContent] {
        promptsEntry.prompts
    }
    
    init(
        coordinator: any Coordinated,
        promptsEntry: PromptsEntry,
        flowCoordinator: PromptChainFlowCoordinator,
        promptsEntryManager: PromptsEntryManager
    ) {
        self.parentCoordinator = coordinator
        self.promptsEntry = promptsEntry
        self.flowCoordinator = flowCoordinator
        self.promptsEntryManager = promptsEntryManager
        self.addFlowStepSubscriber()
    }

    var promptEntryProgressValue: Double {
        let stepsCompleted = Double(flowCoordinator.stepsCompleted)
        let totalSteps: Double = Double(flowCoordinator.steps.count)
        return stepsCompleted/totalSteps
    }

    var progressEmoji: String {
        ProgressEmoji(rawValue: flowCoordinator.stepsCompleted)?.emoji ?? "😑"
    }

    func closeButtonTapped() {
        parentCoordinator.dismissFullScreenOver()
    }

    var showTopBar: Bool {
        flowCoordinator.path.count <= flowCoordinator.steps.count
    }

    func addFlowStepSubscriber() {
        self.cancellable = flowCoordinator.$stepsCompleted.sink { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.promptsEntryManager.save(entry: self.promptsEntry)
            }
        }
    }
}

