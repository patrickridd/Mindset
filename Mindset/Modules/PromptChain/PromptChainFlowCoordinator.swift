//
//  PromptChainFlowCoordinator.swift
//  Mindset
//
//  Created by patrick ridd on 6/5/25.
//

import SwiftUI


class PromptChainFlowCoordinator: FlowCoordinator {

    @Published var path = NavigationPath()
    @Published private(set) var stepsCompleted: Int = 0
    
    private(set) var currentIndex = 0
    let steps: [any PromptContent]
    var onCompletion: () -> Void

    required init(steps: [any PromptContent], onCompletion: @escaping () -> Void) {
        self.steps = steps
        self.onCompletion = onCompletion
        start()
    }

    func start() {
        path = NavigationPath()
        if let first = steps.first {
            path.append(first)
        }
    }
    
    func back() {
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func reset() {
        popToRoot()
        currentIndex = 0
        stepsCompleted = 0
    }

    func next() {
        currentIndex += 1
        if currentIndex < steps.count {
            let step = steps[currentIndex]
            path.append(step)
        } else {
            path.append(PromptCompletionStep())
        }
    }

    func completeStep() {
        stepsCompleted += 1
    }

    func view(for step: any PromptContent) -> AnyView {
        AnyView(
            PromptView(
                viewModel: .init(
                    journalPrompt: step,
                    flowCoordinator: self,
                    promptsEntryManager: PromptsEntryManager(
                        promptsEntryPersistence: PromptsEntryFileStore()
                    )
                )
            )
        )
    }
    
}
