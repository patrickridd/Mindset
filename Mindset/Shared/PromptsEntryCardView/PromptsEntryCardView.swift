//
//  PromptsEntryCardView.swift
//  Mindset
//
//  Created by patrick ridd on 6/28/25.
//

import SwiftUI

struct PromptsEntryCardView: View {
    
    @ObservedObject var viewModel: PromptsEntryCardViewModel

    var body: some View {
        Button(action: viewModel.entryTapped) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Journal for \(viewModel.entry.promptEntryDate.formatted(date: .long, time: .omitted))")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.orange)
                    Spacer()
                    Button(action: viewModel.deleteButtonTapped) {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
                ForEach(viewModel.entry.prompts.indices, id: \.self) { i in
                    // Customize based on actual PromptContent type
                    HStack {
                        Text("• \(viewModel.entry.prompts[i].title)")
                            .font(.subheadline)
                        Text(String(describing: viewModel.entry.prompts[i].entryText))
                            .font(.headline)
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            // Clip background with rounded corners
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.indigo, lineWidth: 1)
                            // Add rounded border
                        )
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    PromptsEntryCardView(
        viewModel: PromptsEntryCardViewModel(entry: PromptsEntry(promptEntryDate: Date(), prompts: [MockPromptContent()], type: .morning), coordinator: Coordinator(), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()))
    )
}

struct MockPromptContent: PromptContent {
    var id: String = UUID().uuidString
    var title: String = "Sample Title"
    var subtitle: String = "Sample Subtitle"
    var date: Date = Date()
    var entryText: String = "Sample Entry"
    var completed: Bool = true
}
