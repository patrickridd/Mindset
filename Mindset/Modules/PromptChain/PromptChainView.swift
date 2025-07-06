//
//  EntryFlowView.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

struct PromptChainView: View {

    @StateObject var viewModel: PromptChainViewModel
    @EnvironmentObject var flowCoordinator: PromptChainFlowCoordinator
    
    var body: some View {
        VStack {
            if viewModel.showTopBar {
                topBarView
                    .padding(.horizontal)
            }
            NavigationStack(path: $flowCoordinator.path) {
                EmptyView()
                    .navigationDestination(for: Prompt.self) { prompt in
                        flowCoordinator.view(for: prompt)
                    }
                    .navigationDestination(for: PromptCompletionStep.self) { completionStep in
                        PromptChainCompletionView(viewModel: .init(completionPrompt: completionStep, coordinator: viewModel.parentCoordinator))
                    }
            }
        }
    }
}

#Preview {
    PromptChainView(viewModel: .init(coordinator: Coordinator(viewFactory: ViewFactory()), promptsEntry: PromptsEntry(promptEntryDate: Date(), prompts: [Prompt.gratitude], type: .morning), flowCoordinator: PromptChainFlowCoordinator(steps: [], onCompletion: {
    }), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()))
    )
}

extension PromptChainView {
    var topBarView: some View {
        HStack {
            closeButton
            ProgressBarView(progress: viewModel.promptEntryProgressValue)
            Button {

            } label: {
//                Image(systemName: "questionmark.circle.fill")
//                    .resizable()
//                    .frame(width: 24, height: 24)
//                    .foregroundStyle(.white)
                Text(viewModel.progressEmoji)
                    .font(.largeTitle)
                    .animation(.easeInOut, value: viewModel.promptEntryProgressValue)
            }
        }
        .padding(.vertical)
    }

    var closeButton: some View {
        Button {
            viewModel.closeButtonTapped()
        } label: {
            Image(systemName: "x.circle.fill")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundStyle(.indigo)
        }
    }
}
