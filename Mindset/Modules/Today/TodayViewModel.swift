//
//  TodayViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/26/25.
//

import SwiftUI

@MainActor
class TodayViewModel: ObservableObject {

    @Published var presentingPromptChainFlow: Bool = false
    @Published var selectedDate: Date
    @Published var promptsEntryManager: PromptsEntryManager
    @Published var dayTime: DayTime
    @Published var moodValue: Int?
    @Published var morningPromptsEntry: PromptsEntry
    @Published var nightPromptsEntry: PromptsEntry

    private(set) var coordinator: any Coordinated
    
    init(coordinator: any Coordinated, promptsEntryManager: PromptsEntryManager, dayTime: DayTime? = nil) {
        self.selectedDate = Calendar.current.startOfDay(for: Date())
        self.promptsEntryManager = promptsEntryManager
        self.coordinator = coordinator
        self.dayTime = dayTime ?? .morning

        self.morningPromptsEntry = promptsEntryManager.getPromptsEntry(for: .startOfToday, dayTime: .morning)
        ??
        promptsEntryManager.createEntry(promptsEntryType: .morning, prompts: DayTime.morning.defaultPrompts)

        self.nightPromptsEntry = promptsEntryManager.getPromptsEntry(for: .startOfToday, dayTime: .night)
        ??
        promptsEntryManager.createEntry(promptsEntryType: .night, prompts: DayTime.night.defaultPrompts)
    }

    var moodValueBinding: Binding<Int?> {
        Binding<Int?>(
            get: { self.moodValue },
            set: { self.moodValue = $0 }
        )
    }

    var todoCardItems: [TodoCardItem] {
        [
            TodoCardItem(
                view: AnyView(MoodEmojiPickerView(selectedIndex: moodValueBinding)), progressStatus: moodProgressStatus
            ),
            TodoCardItem(
                view: AnyView(morningMindsetCard), progressStatus: morningMindsetCardProgress
            ),
            TodoCardItem(
                view: AnyView(nightMindsetCard), progressStatus: nightMindsetCardProgress
            )
        ]
    }

    var currentStep: Int {
        if moodValue == nil {
            return 0
        } else if !morningPromptsEntry.completed {
            return 1
        } else {
            return 2
        }
    }

    var morningMindsetCard: StartPromptsEntryCardView {
        StartPromptsEntryCardView(
            viewModel: .init(
                coordinator: self.coordinator,
                promptsEntryManager: self.promptsEntryManager,
                dayTime: .morning,
                promptsEntry: self.morningPromptsEntry)
        )
    }

    var nightMindsetCard: StartPromptsEntryCardView {
        StartPromptsEntryCardView(
            viewModel: .init(
                coordinator: self.coordinator,
                promptsEntryManager: self.promptsEntryManager,
                dayTime: .night,
                promptsEntry: self.nightPromptsEntry)
        )
    }

    var moodProgressStatus: ProgressStatus {
        if currentStep == 0 || moodValue == nil {
            return .inProgress
        } else {
            return .completed
        }
    }

    var morningMindsetCardProgress: ProgressStatus {
        guard let promptEntry = promptsEntryManager.getPromptsEntry(for: .today, dayTime: .morning) else {
            return .notStarted
        }

        if promptEntry.completed {
            return .completed
        } else if currentStep == 0 {
            return .notStarted
        } else {
            return .inProgress
        }
    }

    var nightMindsetCardProgress: ProgressStatus {
        guard let promptEntry = promptsEntryManager.getPromptsEntry(for: .today, dayTime: .night) else {
            return .notStarted
        }

        if promptEntry.completed {
            return .completed
        } else if currentStep == 2 {
            return .inProgress
        } else {
            return .notStarted
        }
    }
    
    var title: String {
        dayTime == .morning ? "Morning, Patrick!" : "Evening, Patrick!"
    }
    
    var subtitle: String {
        dayTime == .morning ? "Start your day off right!" : "Reflect on your day."
    }

}
