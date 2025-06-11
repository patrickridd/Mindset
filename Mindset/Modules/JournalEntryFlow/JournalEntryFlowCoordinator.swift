//
//  JournalEntryCoordinator.swift
//  Mindset
//
//  Created by patrick ridd on 6/5/25.
//

import SwiftUI


class JournalEntryFlowCoordinator: FlowCoordinator {

    @Published var path = NavigationPath()
    private(set) var currentIndex = 0
    let steps: [any Prompt]
    var onCompletion: () -> Void

    required init(steps: [any Prompt], onCompletion: @escaping () -> Void) {
        self.steps = steps
        self.onCompletion = onCompletion
        start()
    }

    func start() {
        currentIndex = 0
        path = NavigationPath()
        if let first = steps.first {
            path.append(first)
        }
    }
    
    func back() {
        path.removeLast()
    }

    func next() {
        currentIndex += 1
        if currentIndex < steps.count {
            let step = steps[currentIndex]
            path.append(step)
        } else {
            print("🎉 Journal finished.")
            onCompletion()
        }
    }

    func view(for step: any Prompt) -> AnyView {
        if step.id == steps.last?.id {
            return AnyView(JournalEntryCompletionView(viewModel: .init(completionPrompt: step, flowCoordinator: self)))
        }
        let journalPromptView = JournalPromptView(viewModel: .init(journalPrompt: step, flowCoordinator: self))
        return AnyView(journalPromptView)
    }
}
