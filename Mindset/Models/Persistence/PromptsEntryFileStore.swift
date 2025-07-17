//
//  PromptsEntryFileStore.swift
//  Mindset
//
//  Created by patrick ridd on 6/24/25.
//

import Foundation

struct PromptsEntryFileStore: PromptsEntryPersistence {

    let fileManager: FileManager

    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    func fileURL(path: String) -> URL {
        let folder = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return folder.appendingPathComponent(path)
    }

    func loadPrompts(for dayTime: DayTime) -> [PromptsEntry] {
        guard let data = try? Data(contentsOf: fileURL(path: dayTime.urlPath)) else { return [] }
        return (try? JSONDecoder().decode([PromptsEntry].self, from: data)) ?? []
    }

    func saveEntries(_ entries: [PromptsEntry], for dayTime: DayTime) throws {
        if let data = try? JSONEncoder().encode(entries) {
            do {
                try data.write(to: fileURL(path: dayTime.urlPath))
            } catch {
                throw error
            }
        }
    }
    
    func saveEntry(_ entry: PromptsEntry) {
        var existing = loadPrompts(for: entry.dayTime)
        existing.append(entry)
        try? saveEntries(existing, for: entry.dayTime)
    }

    func delete(_ entry: PromptsEntry) {
        var existing = loadPrompts(for: entry.dayTime)
        if let index = existing.firstIndex(of: entry) {
            existing.remove(at: index)
            try? saveEntries(existing, for: entry.dayTime)
        }
    }

}
