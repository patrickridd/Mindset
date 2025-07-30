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

    var moodValueBinding: Binding<Int?> {
        Binding<Int?>(
            get: { self.moodValue },
            set: { self.moodValue = $0 }
        )
    }

    var currentStep: Int {
        let index = todaysEntries.firstIndex(where: { !$0.completed })
        return index ?? 0
    }

    var moodProgressStatus: ProgressStatus {
        if currentStep == 0 || moodValue == nil {
            return .inProgress
        } else {
            return .completed
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

    var morningMindsetCardProgress: ProgressStatus {
        guard let promptEntry = promptsEntryManager.getPromptsEntry(for: .today, dayTime: .morning) else {
            return .inProgress
        }
        if promptEntry.completed {
            return .completed
        } else {
            return .inProgress
        }
    }

    var nightMindsetCardProgress: ProgressStatus {
        guard let promptEntry = promptsEntryManager.getPromptsEntry(for: .today, dayTime: .night) else {
            return .locked
        }
        
        if promptEntry.completed {
            return .completed
        }
        switch morningMindsetCardProgress {
        case .inProgress, .locked:
            return .locked
        case .completed:
            return .inProgress
        }
    }
    
    var title: String {
        dayTime == .morning ? "Morning, Patrick!" : "Evening, Patrick!"
    }
    
    var subtitle: String {
        dayTime == .morning ? "Start your day off right!" : "Reflect on your day."
    }

}
