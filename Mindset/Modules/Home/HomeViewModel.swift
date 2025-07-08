//
//  HomeViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/26/25.
//

import SwiftUI

@MainActor

class HomeViewModel: ObservableObject {
    
    @Published var presentingPromptChainFlow: Bool = false
    @Published var selectedDate: Date
    @Published var promptsEntryManager: PromptsEntryManager
    @Published var dayTime: DayTime
    @Published var moodValue: Int?
    @Published var selectedPrompts: [Prompt]?

    private(set) var coordinator: any Coordinated
    
    init(coordinator: any Coordinated, promptsEntryManager: PromptsEntryManager, dayTime: DayTime? = nil) {
        self.selectedDate = Calendar.current.startOfDay(for: Date())
        self.promptsEntryManager = promptsEntryManager
        self.coordinator = coordinator
        self.dayTime = dayTime ?? .morning
    }
    
    var entry: PromptsEntry? {
        promptsEntryManager.promptEntry(for: selectedDate)
    }
    
    var title: String {
        dayTime == .morning ? "Morning, Patrick!" : "Evening, Patrick!"
    }
    
    var subtitle: String {
        dayTime == .morning ? "Start your day off right!" : "Reflect on your day."
    }
    
    var prompts: [Prompt] {
        selectedPrompts ?? dayTime.defaultPrompts
    }

}

