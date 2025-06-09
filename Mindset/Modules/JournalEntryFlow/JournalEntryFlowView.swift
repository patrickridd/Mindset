//
//  JournalEntryFlowView.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

struct JournalEntryFlowView: View {

    @StateObject var viewModel: JournalEntryFlowViewModel
    @EnvironmentObject var flowCoordinator: JournalEntryCoordinator

    var body: some View {
        VStack {
           topBarView
                .padding(.horizontal)
            NavigationStack(path: $flowCoordinator.path) {
                EmptyView()
                    .navigationDestination(for: JournalPrompt.self) { prompt in
                        flowCoordinator.view(for: prompt)
                    }
            }
        }
    }
}

#Preview {
    JournalEntryFlowView(viewModel: .init(coordinator: Coordinator(), journalEntry: JournalEntry(journalPrompts: [JournalPrompt.gratitude])))
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
