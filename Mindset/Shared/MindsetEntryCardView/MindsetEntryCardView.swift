//
//  MindsetEntryCardView.swift
//  Mindset
//
//  Created by patrick ridd on 6/29/25.
//

import SwiftUI

struct MindsetEntryCardView: View {
    
    @ObservedObject var viewModel: MindsetEntryCardViewModel

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(
                    alignment: .leading,
                    spacing: 8.0
                ) {
                    headlineView
                    promptsDescriptionview
                }
                Spacer()
            }
            .padding()
            playButtonView
                .padding(.bottom)
        }
        .background(viewModel.backgroundColor)
        // Clip background with rounded corners
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            // Add rounded border
            RoundedRectangle(
                cornerRadius: 12
            )
            .stroke(.indigo, lineWidth: 1)
        )
        .padding(.horizontal, 24)
        .sensoryFeedback(viewModel.sensoryFeedback, trigger: viewModel.sensoryFeedbackTrigger)
    }
}

#Preview {
    MindsetEntryCardView(viewModel: .init(coordinator: Coordinator(viewFactory: ViewFactory()), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()), dayTime: .morning, promptsEntry: Mocks.morningMindSet, progressStatus: .inProgress, onDelete: nil))
    
    MindsetEntryCardView(viewModel: .init(coordinator: Coordinator(viewFactory: ViewFactory()), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()), dayTime: .night, promptsEntry: Mocks.nightMindSet, progressStatus: .locked, onDelete: nil))

    MindsetEntryCardView(viewModel: .init(coordinator: Coordinator(viewFactory: ViewFactory()), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()), dayTime: .night, promptsEntry: Mocks.nightMindSet, progressStatus: .completed, onDelete: nil))
}

extension MindsetEntryCardView {
    
    var headlineView: some View {
        HStack(alignment: .center) {
            Text(viewModel.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .foregroundStyle(viewModel.titleForegroundColor)
            Spacer()
            resetButtonView
                .padding(.bottom)
        }
    }
    
    var playButtonView: some View {
        Button {
            viewModel.playButtonTapped()
        } label: {
            PulsingIcon(
                systemName: viewModel.buttonImageName,
                foregroundColor: viewModel.buttonForegroundColor.opacity(0.9),
                borderColor: viewModel.buttonBorderColor,
                isInProgress: viewModel.progressStatus == .inProgress,
                imageSize: 50
            )
        }
    }

    var resetButtonView: some View {
        Button {
            viewModel.resetButtonTapped()
        } label: {
            Image(systemName: "arrow.counterclockwise.circle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(viewModel.rewindColor)
                .opacity(viewModel.progressStatus == .completed ? 1.0 : 0.0)
        }
    }

    var promptsDescriptionview: some View {
        ForEach(Array(viewModel.promptsEntry.prompts.enumerated()), id: \.offset) { (i, prompt) in
            // Customize based on actual PromptContent type
            HStack {
                Text("•")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Text(prompt.title)
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
        }
    }

    var quoteView: some View {
        Text("""
            “When you arise in the morning think of what a privilege it is to be alive, to think, to enjoy, to love ...”
            
            ― Marcus Aurelius, Meditations
            """
        )
        .padding([.horizontal, .top], 40)
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}
