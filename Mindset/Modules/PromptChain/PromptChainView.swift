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
    PromptChainView(viewModel: .init(coordinator: Coordinator(), promptsEntry: PromptsEntry(promptEntryDate: Date(), prompts: [Prompt.gratitude], type: .day), flowCoordinator: PromptChainFlowCoordinator(steps: [], onCompletion: {
    }), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()))
    )
}

extension PromptChainView {
    var topBarView: some View {
        HStack {
            Button {
                viewModel.closeButtonTapped()
            } label: {
                Image(systemName: "x.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            ProgressBarView(progress: viewModel.promptEntryProgressValue)
            Button {

            } label: {
                Text(viewModel.progressEmoji)
                    .font(.largeTitle)
                    .animation(.easeInOut, value: viewModel.promptEntryProgressValue)
            }
        }
    }
}
