//
//  PromptChainCompletionViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/8/25.
//

import Foundation

@MainActor
class PromptChainCompletionViewModel: ObservableObject {
    
    @Published var completionPrompt: any CoordinatedFlowCompletionStep
    let coordinator: any Coordinated

    init(completionPrompt: any CoordinatedFlowCompletionStep, coordinator: any Coordinated) {
        self.completionPrompt = completionPrompt
        self.coordinator = coordinator
    }

    func buttonTapped() {
        coordinator.dismissFullScreenCover()
    }
}
