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
        VStack(spacing: 25.0) {
            HStack {
                VStack(alignment: .leading, spacing: 8.0) {
                    headlineView
                    promptsDescriptionview
                }
                Spacer()
            }
            MoodSliderView()
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
    StartPromptsEntryCardView(viewModel: .init(coordinator: Coordinator(), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore())))
}

extension StartPromptsEntryCardView {
    
    var headlineView: some View {
        HStack(alignment: .center) {
            Text("Morning Mindset")
                .font(.headline)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.orange)
            Image(systemName: "sun.min")
                .foregroundStyle(.yellow)
//            Spacer()
//            Button {
//            } label: {
//                Image(systemName: "slider.horizontal.3")
//                    .foregroundStyle(.indigo)
//            }
//            .padding(.bottom)
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
