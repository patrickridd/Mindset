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
        for entry in morningEntries {
            self.morningEntries.insert(entry)
        }
    }
    
    private func loadNightEntries() {
        let nightEntries = promptsEntryPersistence.loadPrompts(for: .night)
        for entry in nightEntries {
            self.nightEntries.insert(entry)
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
        promptsEntryPersistence.saveEntry(newEntry)
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
