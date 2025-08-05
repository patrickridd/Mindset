// ViewFactory.swift
// This file provides a factory responsible for constructing views for the Coordinator.
import SwiftUI

@MainActor
final class ViewFactory {
    @ViewBuilder
    func makeView(for screen: CoordinatedView, coordinator: Coordinator) -> some View {
        switch screen {
        case .todayView(let promptsEntryManager, let dayTime):
            TodayView(viewModel: TodayViewModel(
                coordinator: coordinator,
                promptsEntryManager: promptsEntryManager,
                profilePersistence: ProfilePersistence(),
                dayTime: dayTime
            ))
        case .trackerView(let promptsEntryManager):
            TrackerView(viewModel: TrackerViewModel(
                coordinator: coordinator,
                promptsEntryManager: promptsEntryManager
            ))
        case .promptView(let prompt, let flowCoordinator, let promptsEntryManager):
            PromptView(viewModel: PromptViewModel(
                journalPrompt: prompt,
                flowCoordinator: flowCoordinator,
                promptsEntryManager: promptsEntryManager
            ))
            .environmentObject(flowCoordinator)
        case .promptsChainView(let promptEntry, let flowCoordinator, let promptsEntryManager):
            PromptChainView(viewModel: PromptChainViewModel(coordinator: coordinator, promptsEntry: promptEntry, flowCoordinator: flowCoordinator, promptsEntryManager: promptsEntryManager))
                .environmentObject(flowCoordinator)
        case .profileView:
            ProfileView(viewModel: ProfileViewModel())
        }
    }
}
