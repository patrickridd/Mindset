//
//  PromptsEntryManager.swift
//  Mindset
//
//  Created by patrick ridd on 6/28/25.
//

import Foundation

/// Manages the loading, creation, retrieval, saving, and deletion of prompts entries for morning and night.
/// 
/// This class maintains separate sets of `PromptsEntry` objects for morning and night time periods, 
/// and interacts with a persistence layer to load and save entries.
/// It is marked as `@MainActor` to ensure all mutations and access happen on the main thread, suitable for UI updates.
/// Use this class to handle daily mindset prompt entries efficiently within the app lifecycle.
@MainActor
class PromptsEntryManager: ObservableObject {
    
    /// The collection of morning prompt entries.
    /// Contains `PromptsEntry` objects associated with morning prompts.
    @Published var morningEntries: Set<PromptsEntry> = []
    
    /// The collection of night prompt entries.
    /// Contains `PromptsEntry` objects associated with night prompts.
    @Published var nightEntries: Set<PromptsEntry> = []

    /// The persistence layer responsible for loading, saving, and deleting prompt entries.
    private let promptsEntryPersistence: PromptsEntryPersistence
    
    /// Initializes a new `PromptsEntryManager` with the given persistence layer.
    /// - Parameter promptsEntryPersistence: The persistence object used to load and save entries.
    /// Upon initialization, loads existing morning and night entries from persistence.
    init(promptsEntryPersistence: PromptsEntryPersistence) {
        self.promptsEntryPersistence = promptsEntryPersistence
        loadMorningEntries()
        loadNightEntries()
    }

    /// Loads the morning prompt entries from the persistence layer and updates the `morningEntries` set.
    private func loadMorningEntries() {
        let morningEntries = promptsEntryPersistence.loadPrompts(for: .morning)
        self.morningEntries = Set(morningEntries)
    }
    
    /// Loads the night prompt entries from the persistence layer and updates the `nightEntries` set.
    private func loadNightEntries() {
        let nightEntries = promptsEntryPersistence.loadPrompts(for: .night)
        self.nightEntries = Set(nightEntries)
    }

    /// Loads today's mindset entries for both morning and night.
    /// - Returns: An array containing today's morning and night `PromptsEntry` objects.
    func loadDailyMindsetEntries() -> [PromptsEntry] {
       [getTodaysMorningEntry(), getTodaysNightEntry()]
    }

    /// Retrieves today's morning prompt entry if it exists, otherwise creates a new one with default morning prompts.
    /// - Returns: A `PromptsEntry` representing today's morning entry.
    func getTodaysMorningEntry() -> PromptsEntry {
        if let savedMorningEntry = getPromptsEntry(for: .today, dayTime: .morning) {
            return savedMorningEntry
        } else {
            return createEntry(promptsEntryType: .morning, prompts: DayTime.morning.defaultPrompts)
        }
    }

    /// Retrieves today's night prompt entry if it exists, otherwise creates a new one with default night prompts.
    /// - Returns: A `PromptsEntry` representing today's night entry.
    func getTodaysNightEntry() -> PromptsEntry {
        if let savedMorningEntry = getPromptsEntry(for: .today, dayTime: .night) {
            return savedMorningEntry
        } else {
            return createEntry(promptsEntryType: .night, prompts: DayTime.night.defaultPrompts)
        }
    }

    /// Creates a new prompt entry for the specified day time with the given prompts, and inserts it into the corresponding set.
    /// - Parameters:
    ///   - promptsEntryType: The time of day (`.morning` or `.night`) for the new entry.
    ///   - prompts: An array of `Prompt` objects to associate with the new entry.
    /// - Returns: The newly created `PromptsEntry` object.
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

    /// Retrieves a prompt entry for a specific date and time of day if it exists.
    /// - Parameters:
    ///   - date: The `Date` to look for.
    ///   - dayTime: The time of day (`.morning` or `.night`) to filter the entry.
    /// - Returns: An optional `PromptsEntry` if one matching the criteria exists.
    func getPromptsEntry(for date: Date, dayTime: DayTime) -> PromptsEntry? {
        switch dayTime {
        case .morning:
            return morningEntries.first { $0.date.inSameDayAs(date: date) }
        case .night:
            return nightEntries.first { $0.date.inSameDayAs(date: date) }
        }
    }

    /// Saves an updated prompt entry, replacing any existing entry for the same date and time.
    /// Also persists the entry using the persistence layer.
    /// - Parameter entry: The `PromptsEntry` to save.
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

    /// Deletes a prompt entry both from the in-memory collection and the persistence layer.
    /// - Parameter entry: The `PromptsEntry` to delete.
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
