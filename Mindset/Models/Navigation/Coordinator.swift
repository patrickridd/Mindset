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
        case .journalPromptView(let prompt):
            JournalPromptView(viewModel: JournalPromptViewModel(journalPrompt: prompt, flowCoordinator: JournalEntryFlowCoordinator(steps: [prompt], onCompletion: { [weak self] in
                self?.dismissFullScreenOver()
            })))
            .environmentObject(JournalEntryFlowCoordinator(steps: [prompt], onCompletion: { [weak self] in
                self?.dismissFullScreenOver()
            }))
        case .journalEntryView(let journalEntry):
            JournalEntryFlowView(viewModel: JournalEntryFlowViewModel(coordinator: self, journalEntry: journalEntry))
                .environmentObject(JournalEntryFlowCoordinator(steps: journalEntry.journalPrompts, onCompletion: { [weak self] in
                    self?.dismissFullScreenOver()
                }))
        }
    }
    
//        @ViewBuilder
//        func build(_ sheet: CoordinatedView) -> some View {
//            switch sheet {
//            case .homeView:
//                HomeView()
//            case .journalPromptView:
//                JournalPromptView()
//            case .journalEntryView:
//                JournalEntryFlowView()
//            }
//        }
//        
//        @ViewBuilder
//        func build(_ fullScreenCover: CoordinatedView) -> some View {
//            switch fullScreenCover {
//            case .homeView:
//                HomeView()
//            case .journalPromptView:
//                JournalPromptView()
//            case .journalEntryView:
//                JournalEntryFlowView()
//            }
//        }
}
