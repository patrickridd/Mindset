//
//  PromptsEntryFileStore.swift
//  Mindset
//
//  Created by patrick ridd on 6/24/25.
//

import Foundation

struct PromptsEntryFileStore: PromptsEntryPersistence {

    var fileURL: URL {
        let manager = FileManager.default
        let folder = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return folder.appendingPathComponent("promptsEntries.json")
    }

    func load() -> [PromptsEntry] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        return (try? JSONDecoder().decode([PromptsEntry].self, from: data)) ?? []
    }

    func save(_ entries: [PromptsEntry]) {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL)
        }
    }

    func add(_ entry: PromptsEntry) {
        var existing = load()
        existing.append(entry)
        save(existing)
    }

    func delete(_ entry: PromptsEntry) {
        var existing = load()
        if let index = existing.firstIndex(of: entry) {
            existing.remove(at: index)
            save(existing)
        }
    }

}
