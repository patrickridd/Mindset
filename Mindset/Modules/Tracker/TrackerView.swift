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
                if let entry = viewModel.entry {
                    PromptEntryCardView(viewModel: PromptEntryCardViewModel(
                        entry: entry,
                        coordinator: viewModel.coordinator,
                        promptsEntryManager: viewModel.promptsEntryManager
                    ))
                }
            }
        }
    }
}

#Preview {
    TrackerView(viewModel: TrackerViewModel(coordinator: Coordinator(), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore())))
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
