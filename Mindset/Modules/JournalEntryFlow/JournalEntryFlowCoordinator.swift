//
//  JournalEntryCoordinator.swift
//  Mindset
//
//  Created by patrick ridd on 6/5/25.
//

import SwiftUI


class JournalEntryFlowCoordinator: FlowCoordinator {

    @Published var path = NavigationPath()
    @Published private(set) var stepsCompleted: Int = 0

    private(set) var currentIndex = 0
    let steps: [any Prompt]
    var onCompletion: () -> Void

    required init(steps: [any Prompt], onCompletion: @escaping () -> Void) {
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
        path.removeLast(path.count-1)
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

    func view(for step: any Prompt) -> AnyView {
        AnyView(
            JournalPromptView(viewModel: .init(journalPrompt: step, flowCoordinator: self))
        )
    }
    
}
