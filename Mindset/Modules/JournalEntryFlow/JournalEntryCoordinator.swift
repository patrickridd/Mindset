//
//  JournalEntryCoordinator.swift
//  Mindset
//
//  Created by patrick ridd on 6/5/25.
//

import SwiftUI


class JournalEntryCoordinator: FlowCoordinator {

    @Published var path = NavigationPath()
    let steps: [any Prompt]
    private var currentIndex = 0
    
    required init(steps: [any Prompt]) {
        self.steps = steps
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
        }
    }

    func view(for step: any Prompt) -> AnyView {
        let journalPromptView = JournalPromptView(viewModel: .init(journalPrompt: step, flowCoordinator: self))
        return AnyView(journalPromptView)
    }

    func currentView() -> AnyView? {
        guard currentIndex < steps.count else {
            return nil
        }
        let step = steps[currentIndex]
        return view(for: step)
    }
}
