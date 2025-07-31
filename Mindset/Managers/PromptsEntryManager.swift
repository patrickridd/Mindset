//
//  PromptsEntryManager.swift
//  Mindset
//
//  Created by patrick ridd on 6/28/25.
//

import Foundation

@MainActor
class PromptsEntryManager: ObservableObject {
    
    @Published var morningEntries: Set<PromptsEntry> = []
    @Published var nightEntries: Set<PromptsEntry> = []

    private let promptsEntryPersistence: PromptsEntryPersistence
    
    init(promptsEntryPersistence: PromptsEntryPersistence) {
        self.promptsEntryPersistence = promptsEntryPersistence
        loadMorningEntries()
        loadNightEntries()
    }

    private func loadMorningEntries() {
        let morningEntries = promptsEntryPersistence.loadPrompts(for: .morning)
        self.morningEntries = Set(morningEntries)
    }
    
    private func loadNightEntries() {
        let nightEntries = promptsEntryPersistence.loadPrompts(for: .night)
        self.nightEntries = Set(nightEntries)
    }

    func loadDailyMindsetEntries() -> [PromptsEntry] {
       [getTodaysMorningEntry(), getTodaysNightEntry()]
    }

    func getTodaysMorningEntry() -> PromptsEntry {
        if let savedMorningEntry = getPromptsEntry(for: .today, dayTime: .morning) {
            return savedMorningEntry
        } else {
            return createEntry(promptsEntryType: .morning, prompts: DayTime.morning.defaultPrompts)
        }
    }

    func getTodaysNightEntry() -> PromptsEntry {
        if let savedMorningEntry = getPromptsEntry(for: .today, dayTime: .night) {
            return savedMorningEntry
        } else {
            return createEntry(promptsEntryType: .night, prompts: DayTime.night.defaultPrompts)
        }
    }

    func createEntry(promptsEntryType: DayTime, prompts: [Prompt]) -> PromptsEntry {
        let newEntry = PromptsEntry(
            prompts: prompts,
            dayTime: promptsEntryType
        )
        switch promptsEntryType {
        case .morning:
            morningEntries.insert(newEntry)
        case .night:
            nightEntries.insert(newEntry)
        }
        return newEntry
    }

    func getPromptsEntry(for date: Date, dayTime: DayTime) -> PromptsEntry? {
        switch dayTime {
        case .morning:
            return morningEntries.first { $0.date.inSameDayAs(date: date) }
        case .night:
            return nightEntries.first { $0.date.inSameDayAs(date: date) }
        }
    }

    func save(entry: PromptsEntry) {
        switch entry.dayTime {
        case .morning:
            morningEntries.remove(entry)
            morningEntries.insert(entry)
        case .night:
            nightEntries.remove(entry)
            nightEntries.insert(entry)
        }
        promptsEntryPersistence.saveEntry(entry)
    }

    func delete(entry: PromptsEntry) {
        switch entry.dayTime {
        case .morning:
            morningEntries.remove(entry)
        case .night:
            nightEntries.remove(entry)
        }
        promptsEntryPersistence.delete(entry)
    }

}
