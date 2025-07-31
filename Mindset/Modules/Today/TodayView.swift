//
//  TodayView.swift
//  Mindset
//
//  Created by patrick ridd on 6/26/25.
//

import SwiftUI

struct TodayView: View {
    
    @StateObject private var viewModel: TodayViewModel

    init(viewModel: TodayViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    VStack(spacing: 12) {
                        quoteView
                            .padding(.top)
                            .fontWeight(.light)
                            .padding(.leading, 2)
                    }
                    .animation(
                        .easeInOut(duration: 0.5),
                        value: viewModel.dayTime
                    )
                    
                    ForEach(viewModel.todaysEntries) { entry in
                        getPromptsEntryCard(for: entry)
                    }
                    .padding(.leading)
                }
            }
        }.task {
            viewModel.loadTodayEntries()
        }
    }
}

#Preview {
    TodayView(
        viewModel: TodayViewModel(
            coordinator: Coordinator(viewFactory: ViewFactory()),
            promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()),
            dayTime: .morning
        )
    )
}

#Preview {
    TodayView(
        viewModel: TodayViewModel(
            coordinator: Coordinator(viewFactory: ViewFactory()),
            promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()),
            dayTime: .night
        )
    )
}

extension TodayView {
    var topBar: some View {
        VStack {
            HStack(alignment: .center) {
                HStack(alignment: .center, spacing: 16) {
                    navTitle
                    StreakTracker()
                    profileButton
                }
            }
            .padding(.top)
            .padding(.horizontal, 16)
            Divider()
        }
    }

    var navTitle: some View {
        Text("Daily Mindset")
            .font(.title)
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

    var buttonTitle: some View {
        Text("Tap to begin")
            .font(.headline)
            .foregroundStyle(.orange)
    }
    
    var quoteView: some View {
        Text("""
            “When you arise in the morning think of what a privilege it is to be alive, to think, to enjoy, to love ...”
            
            ― Marcus Aurelius, Meditations
            """
        )
        .padding([.horizontal], 24)
        .font(.caption)
        .italic()
        .foregroundStyle(.secondary)
    }

    
    func getPromptsEntryCard(for entry: PromptsEntry) -> some View {
        HStack(alignment: .center, spacing: -10) {
            Image(systemName: viewModel.entryCardIconSystemName(for: entry))
                .resizable()
                .frame(width: 24, height: 24)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(viewModel.entryCardIconColor(for: entry))
            MindsetEntryCardView(
                viewModel: .init(
                    coordinator: viewModel.coordinator,
                    promptsEntryManager: viewModel.promptsEntryManager,
                    dayTime: entry.dayTime,
                    promptsEntry: entry,
                    progressStatus: viewModel.progressStatus(for: entry),
                    onDelete: viewModel.loadTodayEntries
                )
            )
        }
    }
}
