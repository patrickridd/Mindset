//
//  StartPromptsEntryCardView.swift
//  Mindset
//
//  Created by patrick ridd on 6/29/25.
//

import SwiftUI

struct StartPromptsEntryCardView: View {
    
    @StateObject var viewModel: StartPromptsEntryCardViewModel

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
        .sensoryFeedback(.selection, trigger: viewModel.startButtonPlayed)
    }
}

#Preview {
    StartPromptsEntryCardView(viewModel: .init(coordinator: Coordinator(viewFactory: ViewFactory()), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()), dayTime: .morning, promptsEntry: Mocks.morningMindSet))
    
    StartPromptsEntryCardView(viewModel: .init(coordinator: Coordinator(viewFactory: ViewFactory()), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()), dayTime: .night, promptsEntry: Mocks.nightMindSet))
}

extension StartPromptsEntryCardView {
    
    var headlineView: some View {
        HStack(alignment: .center) {
            Text(viewModel.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .foregroundStyle(viewModel.titleForegroundColor)
            Spacer()
            editButtonView
                .padding(.bottom)
        }
    }
    
    var playButtonView: some View {
        Button {
            viewModel.playButtonTapped()
        } label: {
            Image(systemName: "square.and.pencil.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.white.opacity(0.9))
        }
    }
    
    var editButtonView: some View {
        Button {
            viewModel.editButtonTapped()
        } label: {
            Image(systemName: "slider.horizontal.3")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundStyle(.indigo)
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
