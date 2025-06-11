//
//  JournalEntryFlowViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

@MainActor
class JournalEntryFlowViewModel: ObservableObject {

    @Published var journalEntry: any JournalEntryContent
    private let parentCoordinator: any Coordinated
    private let flowCoordinator: any FlowCoordinator

    var journalPrompts: [any Prompt] {
        journalEntry.journalPrompts
    }

    init(coordinator: any Coordinated, journalEntry: any JournalEntryContent, flowCoordinator: any FlowCoordinator) {
        self.parentCoordinator = coordinator
        self.journalEntry = journalEntry
        self.flowCoordinator = flowCoordinator
    }

    var journalPromptProgressValue: Double {
        let stepsCompleted = Double(flowCoordinator.stepsCompleted)
        let totalSteps: Double = Double(flowCoordinator.steps.count)
        return stepsCompleted/totalSteps
    }

    func closeButtonTapped() {
        parentCoordinator.dismissFullScreenOver()
    }

}
