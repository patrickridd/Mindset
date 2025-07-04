//
//  HomeView.swift
//  Mindset
//
//  Created by patrick ridd on 6/26/25.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 8) {
                        Text(viewModel.title)
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .frame(width: UIScreen.main.bounds.width-48,
                                   alignment: .leading)
                        Text(viewModel.subtitle)
                            .frame(width: UIScreen.main.bounds.width-48,
                                   alignment: .leading)
                            .font(.headline)
                            .fontWeight(.light)
                            .padding(.leading, 2)
                    }
                    .animation(
                        .easeInOut(duration: 0.5),
                        value: viewModel.dayTime
                    )
                    if let entry = viewModel.entry {
                        PromptsEntryCardView(viewModel: PromptsEntryCardViewModel(
                            entry: entry,
                            coordinator: viewModel.coordinator,
                            promptsEntryManager: viewModel.promptsEntryManager
                        ))
                        .padding(.top)
                    } else {
                        StartPromptsEntryCardView(viewModel: StartPromptsEntryCardViewModel(
                            coordinator: viewModel.coordinator,
                            promptsEntryManager: viewModel.promptsEntryManager,
                            dayTime: viewModel.dayTime,
                            selectedPrompts: viewModel.selectedPrompts
                        ))
                        .animation(
                            .spring(duration: 0.5),
                            value: viewModel.dayTime
                        )
                    }
                }
                .padding(.top, 25)
                Text("""
                    “When you arise in the morning think of what a privilege it is to be alive, to think, to enjoy, to love ...”
                    
                    ― Marcus Aurelius, Meditations
                    """
                )
                .font(.footnote)
                .padding([.horizontal, .top], 40)
                .italic()
            }
        }
    }
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(
            coordinator: Coordinator(viewFactory: ViewFactory()),
            promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()),
            dayTime: .morning
        )
    )
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(
            coordinator: Coordinator(viewFactory: ViewFactory()),
            promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()),
            dayTime: .night
        )
    )
}

extension HomeView {
    var topBar: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
                    DayTimePicker(dayTime: $viewModel.dayTime)
                }
                Spacer()
                HStack(alignment: .top, spacing: 16) {
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

    var buttonTitle: some View {
        Text("Tap to begin")
            .font(.headline)
            .foregroundStyle(.orange)
    }
}

extension DayTime {
    var displayName: String {
        switch self {
        case .morning: return "☀️"
        case .night: return "🌙"
        }
    }
}

