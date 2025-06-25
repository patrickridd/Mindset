//
//  PromptChainViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

@MainActor
class PromptChainViewModel: ObservableObject {

    @Published var journalEntry: any PromptsEntryContent
    private let parentCoordinator: any Coordinated
    private let flowCoordinator: any FlowCoordinator

    var journalPrompts: [any PromptContent] {
        journalEntry.prompts
    }

    init(coordinator: any Coordinated, journalEntry: any PromptsEntryContent, flowCoordinator: any FlowCoordinator) {
        self.parentCoordinator = coordinator
        self.journalEntry = journalEntry
        self.flowCoordinator = flowCoordinator
    }

    var journalPromptProgressValue: Double {
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

}
