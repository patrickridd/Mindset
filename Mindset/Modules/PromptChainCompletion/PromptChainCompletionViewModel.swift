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
    let onCompletion: () -> Void

    init(completionPrompt: any CoordinatedFlowCompletionStep, coordinator: any Coordinated, onCompletion: @escaping () -> Void) {
        self.completionPrompt = completionPrompt
        self.coordinator = coordinator
        self.onCompletion = onCompletion
    }

    func buttonTapped() {
        onCompletion()
        coordinator.dismissFullScreenCover()
    }
}
