//
//  JournalEntryFlowView.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

struct JournalEntryFlowView: View {

    @StateObject var viewModel: JournalEntryFlowViewModel
    @EnvironmentObject var flowCoordinator: JournalEntryFlowCoordinator

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
                        JournalEntryCompletionView(viewModel: .init(completionPrompt: completionStep, flowCoordinator: flowCoordinator))
                    }
            }
        }
    }
}

#Preview {
    JournalEntryFlowView(viewModel: .init(coordinator: Coordinator(), journalEntry: JournalEntry(journalPrompts: [JournalPrompt.gratitude]), flowCoordinator: JournalEntryFlowCoordinator(steps: [], onCompletion: {
    })))
}

extension JournalEntryFlowView {
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
                Text("😎")
                    .font(.largeTitle)
            }
        }
    }
}
