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
    
    @Published var entries: [Date: PromptsEntry] = [:]
    private let promptsEntryPersistence: PromptsEntryPersistence

    public static let shared = PromptsEntryManager(
        promptsEntryPersistence: PromptsEntryFileStore()
    )
    
    init(promptsEntryPersistence: PromptsEntryPersistence) {
        self.promptsEntryPersistence = promptsEntryPersistence
        loadJournalEntries()
    }

    private func loadJournalEntries() {
        let entries = promptsEntryPersistence.load()
        for entry in entries {
            self.entries[Calendar.current.startOfDay(for: entry.promptEntryDate)] = entry
        }
    }

    func createEntry(for selectedDate: Date, moodValue: Double, promptsEntryType: DayTime) -> PromptsEntry {
        let newEntry = PromptsEntry(
            promptEntryDate: selectedDate.startOfDay,
            prompts: [.gratitude, Prompt.affirmation, .goalSetting],
            type: promptsEntryType,
            moodValue: moodValue
        )
        entries[selectedDate.startOfDay] = newEntry
        promptsEntryPersistence.save([newEntry])
        return newEntry
    }

    func promptEntry(for date: Date) -> PromptsEntry? {
        entries[Calendar.current.startOfDay(for: date.startOfDay)]
    }

    func save(entry: PromptsEntry) {
        entries[entry.promptEntryDate.startOfDay] = entry
        promptsEntryPersistence.save([entry])
    }

    func delete(entry: PromptsEntry) {
        guard
            let index = entries.values.firstIndex(of: entry)
        else {
            return
        }
        entries.remove(at: index)
        promptsEntryPersistence.delete(entry)
    }

}
