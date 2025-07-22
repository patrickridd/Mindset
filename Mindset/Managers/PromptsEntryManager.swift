//
//  PromptsEntryManager.swift
//  Mindset
//
//  Created by patrick ridd on 6/28/25.
//

import Foundation

protocol PromptsEntryManagerProtocol {
    
}

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
            self.morningEntries[Calendar.current.startOfDay(for: entry.date)] = entry
        }
    }
    
    private func loadNightEntries() {
        let nightEntries = promptsEntryPersistence.loadPrompts(for: .night)
        for entry in nightEntries {
            self.nightEntries[Calendar.current.startOfDay(for: entry.date)] = entry
        }
    }

    func createEntry(moodValue: Double, promptsEntryType: DayTime, prompts: [Prompt]) -> PromptsEntry {
        let newEntry = PromptsEntry(
            prompts: prompts,
            dayTime: promptsEntryType
        )
        let key = Calendar.current.startOfDay(for: newEntry.date)
        switch promptsEntryType {
        case .morning:
            morningEntries[key] = newEntry
        case .night:
            nightEntries[key] = newEntry
        }
        promptsEntryPersistence.saveEntry(newEntry)
        return newEntry
    }

    func promptEntry(for date: Date, dayTime: DayTime) -> PromptsEntry? {
        let key = Calendar.current.startOfDay(for: date)
        switch dayTime {
        case .morning:
            return morningEntries[key]
        case .night:
            return nightEntries[key]
        }
    }

    func save(entry: PromptsEntry) {
        let key = Calendar.current.startOfDay(for: entry.date)
        switch entry.dayTime {
        case .morning:
            morningEntries[key] = entry
        case .night:
            nightEntries[key] = entry
        }
        promptsEntryPersistence.saveEntry(entry)
    }

    func delete(entry: PromptsEntry) {
        let key = Calendar.current.startOfDay(for: entry.date)
        switch entry.dayTime {
        case .morning:
            morningEntries.removeValue(forKey: key)
        case .night:
            nightEntries.removeValue(forKey: key)
        }
        promptsEntryPersistence.delete(entry)
    }

}
