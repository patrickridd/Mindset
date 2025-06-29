//
//  PromptChainCompletionViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/8/25.
//

import Foundation

@MainActor
class PromptChainCompletionViewModel: ObservableObject {
    
    @Published var flowCoordinator: any FlowCoordinator
    @Published var completionPrompt: any CoordinatedFlowCompletionStep

    init(completionPrompt: any CoordinatedFlowCompletionStep, flowCoordinator: any FlowCoordinator) {
        self.completionPrompt = completionPrompt
        self.flowCoordinator = flowCoordinator
    }

    func buttonTapped() {
        flowCoordinator.onCompletion()
    }
}
