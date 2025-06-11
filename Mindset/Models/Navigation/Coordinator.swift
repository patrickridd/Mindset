//
//  AppCoordinator.swift
//  Mindset
//
//  Created by patrick ridd on 6/4/25.
//

import SwiftUI

class Coordinator: Coordinated {
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: CoordinatedView?
    @Published var fullScreenCover: CoordinatedView?
    
    func push(_ screen: CoordinatedView) {
        path.append(screen)
    }
    
    func presentSheet(_ sheet: CoordinatedView) {
        self.sheet = sheet
    }
    
    func presentFullScreenCover(_ fullScreenCover: CoordinatedView) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    func dismissFullScreenOver() {
        fullScreenCover = nil
    }

    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: CoordinatedView) -> some View {
        switch screen {
        case .homeView:
            HomeView(viewModel: HomeViewModel(coordinator: self))
        case .journalPromptView(let prompt, let flowCoordinator):
            JournalPromptView(viewModel: JournalPromptViewModel(
                journalPrompt: prompt,
                flowCoordinator: flowCoordinator
            ))
            .environmentObject(flowCoordinator)
        case .journalEntryView(let journalEntry, let flowCoordinator):
            JournalEntryFlowView(viewModel: JournalEntryFlowViewModel(coordinator: self, journalEntry: journalEntry, flowCoordinator: flowCoordinator))
                .environmentObject(flowCoordinator)
        }
    }
}
