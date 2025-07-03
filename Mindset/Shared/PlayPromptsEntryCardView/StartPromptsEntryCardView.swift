//
//  StartPromptsEntryCardView.swift
//  Mindset
//
//  Created by patrick ridd on 6/29/25.
//

import SwiftUI

struct StartPromptsEntryCardView: View {
    
    @ObservedObject var viewModel: StartPromptsEntryCardViewModel

    var body: some View {
        VStack(spacing: 25.0) {
            HStack {
                VStack(alignment: .leading, spacing: 8.0) {
                    headlineView
                    promptsDescriptionview
                }
                Spacer()
            }
            MoodSliderView(moodValue: $viewModel.moodValue)
                .onChange(of: viewModel.moodValue) { _, _ in
                    if !viewModel.hasInteractedWithMoodSlider {
                        viewModel.hasInteractedWithMoodSlider = true
                    }
                }
            playButtonView
        }
        .padding()
        .background(Color(.secondarySystemBackground.withAlphaComponent(0.7)))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        // Clip background with rounded corners
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.indigo, lineWidth: 1)
                        // Add rounded border
                    )
        .padding(.horizontal, 24)
        .sensoryFeedback(.selection, trigger: viewModel.promptEntry)
    }
}

#Preview {
    StartPromptsEntryCardView(viewModel: .init(coordinator: Coordinator(viewFactory: ViewFactory()), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()), dayTime: .morning))
    
    StartPromptsEntryCardView(viewModel: .init(coordinator: Coordinator(viewFactory: ViewFactory()), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()), dayTime: .night))
}

extension StartPromptsEntryCardView {
    
    var headlineView: some View {
        HStack(alignment: .center) {
            Text(viewModel.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.orange)
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
        }
        .disabled(!viewModel.hasInteractedWithMoodSlider)
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
        ForEach(Array(viewModel.promptEntry.prompts.enumerated()), id: \.offset) { (i, prompt) in
            // Customize based on actual PromptContent type
            HStack {
                Text("•")
                    .font(.subheadline)
                    .foregroundStyle(.orange)
                Text(prompt.title)
                    .font(.subheadline)
            }
        }
    }
}

