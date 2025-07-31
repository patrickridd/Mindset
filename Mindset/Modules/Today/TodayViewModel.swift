//
//  TodayViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/26/25.
//

import SwiftUI
import Combine

@MainActor
class TodayViewModel: ObservableObject {

    @Published var presentingPromptChainFlow: Bool = false
    @Published var selectedDate: Date
    @Published var promptsEntryManager: PromptsEntryManager
    @Published var dayTime: DayTime
    @Published var moodValue: Int?
    @Published var todaysEntries: [PromptsEntry] = []
    
    private var entryCancellables: [AnyCancellable] = []
    private(set) var coordinator: any Coordinated
    
    init(
        coordinator: any Coordinated,
        promptsEntryManager: PromptsEntryManager,
        dayTime: DayTime? = nil
    ) {
        self.selectedDate = Calendar.current.startOfDay(for: Date())
        self.promptsEntryManager = promptsEntryManager
        self.coordinator = coordinator
        self.dayTime = dayTime ?? .morning
    }

    var title: String {
        dayTime == .morning ? "Good Morning!" : "Evening wind down..."
    }
    
    var subtitle: String {
        dayTime == .morning ? "Start your day off right!" : "Lets put this day to bed."
    }

    func loadTodayEntries() {
        self.todaysEntries = promptsEntryManager.loadDailyMindsetEntries()
        entryCancellables = []
        for entry in todaysEntries {
            let cancellable = entry.$completed.sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            entryCancellables.append(cancellable)
        }
    }

    func progressStatus(for entry: PromptsEntry) -> ProgressStatus {
        switch entry.dayTime {
        case .morning:
            if entry.completed {
                return .completed
            } else {
                return .inProgress
            }
        case .night:
            if entry.completed {
                return .completed
            } else {
                guard let morningEntry = promptsEntryManager.getPromptsEntry(for: .today, dayTime: .morning) else {
                    return .locked
                }
                if morningEntry.completed {
                    return .inProgress
                } else {
                    return .locked
                }
            }
        }
    }

    func entryCardIconSystemName(for entry: PromptsEntry) -> String {
        switch progressStatus(for: entry) {
        case .completed:
            return "checkmark.circle.fill"
        case .inProgress:
            return "circle.fill"
        case .locked:
            return "circle.dashed"
        }
    }

    func entryCardIconColor(for entry: PromptsEntry) -> Color {
        switch progressStatus(for: entry) {
        case .completed:
            return .green
        case .inProgress:
            switch entry.dayTime {
            case .morning:
                return .yellow
            case .night:
                return .yellow.opacity(0.8)
            }
        case .locked:
            return .gray
        }
    }
    
    func entryCardIconBorderColor(for entry: PromptsEntry) -> Color {
        switch progressStatus(for: entry) {
        case .completed, .locked:
            return .clear
        case .inProgress:
            switch entry.dayTime {
            case .morning:
                return .orange
            case .night:
                return .indigo
            }
        }
    }

    func pulsatingIconSize(for entry: PromptsEntry) -> CGFloat {
        switch progressStatus(for: entry) {
        case .completed, .locked:
            return 24
        case .inProgress:
            return 18
        }
    }
}
