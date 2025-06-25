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
            topBarView
                .padding(.horizontal)
            NavigationStack(path: $flowCoordinator.path) {
                EmptyView()
                    .navigationDestination(for: JournalPrompt.self) { prompt in
                        flowCoordinator.view(for: prompt)
                    }
                    .navigationDestination(for: PromptCompletionStep.self) { completionStep in
                        PromptChainCompletionView(viewModel: .init(completionPrompt: completionStep, flowCoordinator: flowCoordinator))
                    }
            }
        }
    }
}

#Preview {
    PromptChainView(viewModel: .init(coordinator: Coordinator(), journalEntry: JournalEntry(journalPrompts: [JournalPrompt.gratitude]), flowCoordinator: PromptChainFlowCoordinator(steps: [], onCompletion: {
    })))
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
            ProgressBarView(progress: viewModel.journalPromptProgressValue)
            Button {

            } label: {
                Text(viewModel.progressEmoji)
                    .font(.largeTitle)
                    .animation(.easeInOut, value: viewModel.journalPromptProgressValue)
            }
        }
    }
}
