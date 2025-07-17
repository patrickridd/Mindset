//
//  ChartViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

@MainActor
class TrackerViewModel: ObservableObject {

    @Published var selectedDate: Date
    @Published var presentingPromptChainFlow: Bool = false

    let coordinator: any Coordinated
    let promptsEntryManager: PromptsEntryManager

    var buttonDisabled: Bool {
        !Calendar.current.isDate(selectedDate, inSameDayAs: Date())
    }

    init(coordinator: any Coordinated, promptsEntryManager: PromptsEntryManager) {
        self.selectedDate = Calendar.current.startOfDay(for: Date())
        self.promptsEntryManager = promptsEntryManager
        self.coordinator = coordinator
    }

    var morningEntry: PromptsEntry? {
        promptsEntryManager.promptEntry(for: selectedDate, dayTime: .morning)
    }

}
