//
//  PromptChainCompletionView.swift
//  Mindset
//
//  Created by patrick ridd on 6/8/25.
//

import SwiftUI

struct PromptChainCompletionView: View {

    @StateObject var viewModel: PromptChainCompletionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(viewModel.completionPrompt.title)
                .font(.largeTitle)
            Text(viewModel.completionPrompt.subtitle)
                .font(.title)
            Spacer()
            
            Button(action: {
                viewModel.buttonTapped()
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
                .sensoryFeedback(.success, trigger: viewModel.coordinator.fullScreenCover)
            }
            .padding(.bottom)
        }
        .padding([.horizontal, .top])
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            SoundPlayer().playEntryComplete()
        }
    }
}

#Preview {
    PromptChainCompletionView(viewModel: .init(completionPrompt: PromptCompletionStep(), coordinator: Coordinator(viewFactory: ViewFactory())))
}
