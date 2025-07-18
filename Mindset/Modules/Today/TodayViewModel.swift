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
    @Published var morningSelectedPrompts: [Prompt]?
    @Published var nightSelectedPrompts: [Prompt]?

    private(set) var coordinator: any Coordinated

    init(coordinator: any Coordinated, promptsEntryManager: PromptsEntryManager, dayTime: DayTime? = nil) {
        self.selectedDate = Calendar.current.startOfDay(for: Date())
        self.promptsEntryManager = promptsEntryManager
        self.coordinator = coordinator
        self.dayTime = dayTime ?? .morning
    }

    var moodValueBinding: Binding<Int?> {
        Binding<Int?>(
            get: { self.moodValue },
            set: { self.moodValue = $0 }
        )
    }

    var todoCardItems: [TodoCardItem] {
        [
            TodoCardItem(view: AnyView(MoodEmojiPickerView(selectedIndex: moodValueBinding)), progressStatus: moodProgressStatus),
            TodoCardItem(view: AnyView(morningMindsetCard), progressStatus: morningMindsetCardProgress),
            TodoCardItem(view: AnyView(nightMindsetCard), progressStatus: nightMindsetCardProgress)
        ]
    }

    var currentStep: Int {
        if moodValue == nil {
            return 0
        } else if morningPromptsEntry.completed {
            return 1
        } else if nightPromptsEntry.completed {
            return 2
        } else {
            return todoCardItems.count-1
        }
    }

    var morningPromptsEntry: PromptsEntry {
        promptsEntryManager.promptEntry(for: .startOfToday, dayTime: .morning)
        ??
        PromptsEntry(entryDate: .startOfToday, prompts: morningSelectedPrompts
                     ??
                     DayTime.morning.defaultPrompts, dayTime: .morning)
    }

    var nightPromptsEntry: PromptsEntry {
        promptsEntryManager.promptEntry(for: .endOfToday, dayTime: .night)
        ??
        PromptsEntry(entryDate: .endOfToday, prompts: nightSelectedPrompts
                     ??
                     DayTime.night.defaultPrompts, dayTime: .night)
    }

    var morningMindsetCard: StartPromptsEntryCardView {
        StartPromptsEntryCardView(
            viewModel: .init(
                coordinator: coordinator,
                promptsEntryManager: promptsEntryManager,
                dayTime: .morning,
                promptsEntry: morningPromptsEntry)
        )
    }

    var nightMindsetCard: StartPromptsEntryCardView {
        StartPromptsEntryCardView(
            viewModel: .init(
                coordinator: coordinator,
                promptsEntryManager: promptsEntryManager,
                dayTime: .night,
                promptsEntry: nightPromptsEntry)
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
        guard promptsEntryManager.promptEntry(for: .today, dayTime: .morning)?.completed == nil else {
            return .completed
        }

        if currentStep == 0 {
            return .notStarted
        } else {
            return .inProgress
        }
    }

    var nightMindsetCardProgress: ProgressStatus {
        guard promptsEntryManager.promptEntry(for: .today, dayTime: .night)?.completed == nil else {
            return .completed
        }

        if currentStep == 2 {
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
