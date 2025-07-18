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
                        PromptChainCompletionView(viewModel: .init(completionPrompt: completionStep, coordinator: viewModel.parentCoordinator, onCompletion: flowCoordinator.onCompletion))
                    }
            }
        }
    }
}

#Preview {
    let flowCoordinator = PromptChainFlowCoordinator(steps: [], onCompletion: { })
    return PromptChainView(
        viewModel: .init(
            coordinator: Coordinator(viewFactory: ViewFactory()),
            promptsEntry: PromptsEntry(entryDate: Date(), prompts: [Prompt.gratitude], dayTime: .morning),
            flowCoordinator: flowCoordinator,
            promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore())
        )
    )
    .environmentObject(flowCoordinator)
}

extension PromptChainView {
    var topBarView: some View {
        HStack {
            closeButton
            HorizontalProgressBarView(progress: viewModel.promptEntryProgressValue)
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
        .background(Color(uiColor: .systemBackground))
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
