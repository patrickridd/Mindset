//
//  HomeView.swift
//  Mindset
//
//  Created by patrick ridd on 6/26/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel: HomeViewModel
    @State var contentHeights: [CGFloat] = Array(repeating: 0, count: 3)
    
    init(viewModel: HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    VStack(spacing: 12) {
//                        Text(viewModel.title)
//                            .font(.largeTitle)
//                            .fontWeight(.medium)
//                            .frame(width: UIScreen.main.bounds.width-48,
//                                   alignment: .leading)
//                        Text(viewModel.subtitle)
//                            .frame(width: UIScreen.main.bounds.width-48,
//                                   alignment: .leading)
                        quoteView
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
                        VerticalProgressBarView(todoCardItems: [
                            TodoCardItem(view: AnyView(MoodEmojiPickerView(selectedIndex: $viewModel.moodValue)), progressStatus: viewModel.moodValue == nil ? .inProgress : .completed),
                            TodoCardItem(view: AnyView(StartPromptsEntryCardView(viewModel: .init(coordinator: viewModel.coordinator, promptsEntryManager: viewModel.promptsEntryManager, dayTime: .morning, selectedPrompts: DayTime.morning.defaultPrompts))), progressStatus: .inProgress),
                            TodoCardItem(view: AnyView(StartPromptsEntryCardView(viewModel: .init(coordinator: viewModel.coordinator, promptsEntryManager: viewModel.promptsEntryManager, dayTime: .night, selectedPrompts: DayTime.night.defaultPrompts))), progressStatus: .notStarted)
                        ], currentStep: 0)
                    }
                }
            }
            .padding(.top)
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
                VStack(alignment: .leading, spacing: 8) {
                    navTitle
                    HStack {
                        DayTimePicker(
                            dayTime: $viewModel.dayTime
                        )
                        .padding(.leading, 3)
                        Spacer()
                        HStack(alignment: .top, spacing: 16) {
                            StreakTracker()
                            profileButton
                        }
                    }
                }
            }
            .padding(.top)
            .padding(.horizontal, 16)

//            Divider()
        }
    }

    var navTitle: some View {
        Text("Daily Mindset")
            .font(.title2)
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
}
