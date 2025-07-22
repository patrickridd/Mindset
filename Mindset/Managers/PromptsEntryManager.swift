//
//  PromptsEntryManager.swift
//  Mindset
//
//  Created by patrick ridd on 6/28/25.
//

import Foundation

@MainActor
class PromptsEntryManager: ObservableObject {
    
    @Published var morningEntries: [Date: PromptsEntry] = [:]
    @Published var nightEntries: [Date: PromptsEntry] = [:]

    private let promptsEntryPersistence: PromptsEntryPersistence

    public static let shared = PromptsEntryManager(
        promptsEntryPersistence: PromptsEntryFileStore()
    )
    
    init(promptsEntryPersistence: PromptsEntryPersistence) {
        self.promptsEntryPersistence = promptsEntryPersistence
        loadMorningEntries()
        loadNightEntries()
    }

    private func loadMorningEntries() {
        let morningEntries = promptsEntryPersistence.loadPrompts(for: .morning)
        for entry in morningEntries {
            self.morningEntries[entry.date.startOfDay] = entry
        }
    }
    
    private func loadNightEntries() {
        let nightEntries = promptsEntryPersistence.loadPrompts(for: .night)
        for entry in nightEntries {
            self.nightEntries[entry.date.startOfDay] = entry
        }
    }

    func createEntry(promptsEntryType: DayTime, prompts: [Prompt]) -> PromptsEntry {
        let newEntry = PromptsEntry(
            prompts: prompts,
            dayTime: promptsEntryType
        )
        let key = newEntry.date.startOfDay
        switch promptsEntryType {
        case .morning:
            morningEntries[key] = newEntry
        case .night:
            nightEntries[key] = newEntry
        }
        promptsEntryPersistence.saveEntry(newEntry)
        return newEntry
    }

    func getPromptsEntry(for date: Date, dayTime: DayTime) -> PromptsEntry? {
        let key = date.startOfDay
        switch dayTime {
        case .morning:
            return morningEntries[key]
        case .night:
            return nightEntries[key]
        }
    }

    func save(entry: PromptsEntry) {
        let key = entry.date.startOfDay
        switch entry.dayTime {
        case .morning:
            morningEntries[key] = entry
        case .night:
            nightEntries[key] = entry
        }
        promptsEntryPersistence.saveEntry(entry)
    }

    func delete(entry: PromptsEntry) {
        let key = entry.date.startOfDay
        switch entry.dayTime {
        case .morning:
            morningEntries.removeValue(forKey: key)
        case .night:
            nightEntries.removeValue(forKey: key)
        }
        promptsEntryPersistence.delete(entry)
    }

}
