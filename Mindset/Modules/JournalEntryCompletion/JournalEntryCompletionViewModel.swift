//
//  JournalEntryCompletionViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/8/25.
//

import Foundation

@MainActor
class JournalEntryCompletionViewModel: ObservableObject {
    
    @Published var flowCoordinator: any FlowCoordinator
    @Published var completionPrompt: any CoordinatedFlowCompletionStep

    init(completionPrompt: any CoordinatedFlowCompletionStep, flowCoordinator: any FlowCoordinator) {
        self.completionPrompt = completionPrompt
        self.flowCoordinator = flowCoordinator
    }

    func continueButtonTapped() {
        flowCoordinator.onCompletion()
    }
}
