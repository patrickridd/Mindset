//
//  JournalEntryCompletionView.swift
//  Mindset
//
//  Created by patrick ridd on 6/8/25.
//

import SwiftUI

struct JournalEntryCompletionView: View {

    @StateObject var viewModel: JournalEntryCompletionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(viewModel.completionPrompt.title)
                .font(.largeTitle)
            Text(viewModel.completionPrompt.subtitle)
                .font(.title)
            Spacer()
            
            Button(action: {
                viewModel.continueButtonTapped()
            }) {
                HStack {
                    Text("DONE")
                        .font(.headline)
                    Image(systemName: "heart")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.green)
                .cornerRadius(12)
                .sensoryFeedback(.success, trigger: viewModel.flowCoordinator.path)
            }
            .padding(.bottom)
        }
        .padding([.horizontal, .top])
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    JournalEntryCompletionView(viewModel: .init(completionPrompt: PromptCompletionStep(), flowCoordinator: JournalEntryFlowCoordinator(steps: [], onCompletion: {})))
}
