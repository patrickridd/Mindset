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
            self.morningEntries[Calendar.current.startOfDay(for: entry.date)] = entry
        }
    }

    func createEntry(for selectedDate: Date, moodValue: Double, promptsEntryType: DayTime, prompts: [Prompt]) -> PromptsEntry {
        let newEntry = PromptsEntry(
            entryDate: selectedDate.startOfDay,
            prompts: prompts,
            dayTime: promptsEntryType
        )
        morningEntries[selectedDate.startOfDay] = newEntry
        promptsEntryPersistence.saveEntry(newEntry)
        return newEntry
    }

    func promptEntry(for date: Date, dayTime: DayTime) -> PromptsEntry? {
        switch dayTime {
        case .morning:
            return morningEntries[Calendar.current.startOfDay(for: date)]
        case .night:
            return morningEntries[date.endOfDay]
        }
    }

    func save(entry: PromptsEntry) {
        switch entry.dayTime {
        case .morning:
            morningEntries[entry.date] = entry
        case .night:
            nightEntries[entry.date] = entry
        }
        promptsEntryPersistence.saveEntry(entry)
    }

    func delete(entry: PromptsEntry) {
        guard
            let index = morningEntries.values.firstIndex(of: entry)
        else {
            return
        }
        morningEntries.remove(at: index)
        promptsEntryPersistence.delete(entry)
    }

}
