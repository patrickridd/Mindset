//
//  TrackerView.swift
//  Mindset
//
//  Created by patrick ridd on 5/14/25.
//

import SwiftUI

struct TrackerView: View {

    @StateObject private var viewModel: TrackerViewModel

    init(viewModel: TrackerViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 8) {
            CalendarWeekView(selectedDate: $viewModel.selectedDate)
                .padding(.top)
            ScrollView(showsIndicators: false) {
                // Show entry for selected day if it exists
                if let entry = $viewModel.journalEntry.wrappedValue {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Journal for \(entry.promptEntryDate.formatted(date: .long, time: .omitted))")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.orange)
                            Spacer()
                            Button(action: viewModel.deleteEntry) {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                        }
                        ForEach(entry.prompts.indices, id: \.self) { i in
                            // Customize based on actual PromptContent type
                            HStack {
                                Text("• \(entry.prompts[i].title):")
                                    .font(.subheadline)
                                Text(String(describing: entry.prompts[i].entryText))
                                    .font(.headline)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .animation(.easeInOut, value: viewModel.journalEntry == nil)
                }
            }
        }
    }
}

#Preview {
    TrackerView(viewModel: TrackerViewModel(coordinator: Coordinator(), promptsEntryPersistence: PromptsEntryFileStore()))
}

extension TrackerView {

    var topBar: some View {
        HStack(alignment: .center) {
            navTitle
            Spacer()
            HStack(spacing: 16) {
                StreakTracker()
                profileButton
            }
        }
        .padding(.horizontal, 16)
    }

    var navTitle: some View {
        Text("Mindset")
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity,
                   alignment: .leading)
    }

    var profileButton: some View {
        Button {
            
        } label: {
           Image(systemName: "person.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.indigo)
        }
    }
}
