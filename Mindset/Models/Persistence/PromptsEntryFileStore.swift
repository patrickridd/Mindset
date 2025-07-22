//
//  PromptsEntryFileStore.swift
//  Mindset
//
//  Created by patrick ridd on 6/24/25.
//

import Foundation

struct PromptsEntryFileStore: PromptsEntryPersistence {

    private let fileManager: FileManager

    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    func fileURL(path: String) -> URL {
        let folder = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return folder.appendingPathComponent(path)
    }

    func loadPrompts(for dayTime: DayTime) -> Set<PromptsEntry> {
        guard let data = try? Data(contentsOf: fileURL(path: dayTime.urlPath)),
              let decoded = try? JSONDecoder().decode([PromptsEntry].self, from: data) else {
            return []
        }
        return Set(decoded)
    }

    func saveEntries(_ entries: Set<PromptsEntry>, for dayTime: DayTime) throws {
        let filteredEntries = entries.filter { $0.dayTime == dayTime }
        let filteredArray = Array(filteredEntries)
        if let data = try? JSONEncoder().encode(filteredArray) {
            do {
                try data.write(to: fileURL(path: dayTime.urlPath))
            } catch {
                throw error
            }
        }
    }
    
    func saveEntry(_ entry: PromptsEntry) {
        var existing = loadPrompts(for: entry.dayTime)
        existing.remove(entry)
        existing.insert(entry)
        try? saveEntries(existing, for: entry.dayTime)
    }

    func delete(_ entry: PromptsEntry) {
        var existing = loadPrompts(for: entry.dayTime)
        existing.remove(entry)
        try? saveEntries(existing, for: entry.dayTime)
    }

}
