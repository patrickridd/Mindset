//
//  PromptsEntryStore.swift
//  Mindset
//
//  Created by patrick ridd on 6/24/25.
//

import Foundation

struct PromptsEntryStore {
    static let fileURL: URL = {
        let manager = FileManager.default
        let folder = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return folder.appendingPathComponent("promptsEntries.json")
    }()

    static func load() -> [PromptsEntry] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        return (try? JSONDecoder().decode([PromptsEntry].self, from: data)) ?? []
    }

    static func save(_ entries: [PromptsEntry]) {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL)
        }
    }

    static func addEntry(_ entry: PromptsEntry) {
        var existing = load()
        existing.append(entry)
        save(existing)
    }
}
