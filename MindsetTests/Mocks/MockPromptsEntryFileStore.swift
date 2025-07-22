//
//  MockPromptsEntryFileStore.swift
//  MindsetTests
//
//  Created by patrick ridd on 7/17/25.
//

import Foundation
@testable import Mindset

class MockPromptsEntryFileStore: PromptsEntryPersistence {
    
    var savedEntries: Set<PromptsEntry> = []

    func fileURL(path: String) -> URL {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return URL(fileURLWithPath: path, relativeTo: cacheURL)
    }

    func loadPrompts(for dayTime: DayTime) -> Set<PromptsEntry> {
        []
    }
    
    func saveEntries(_ entries: Set<PromptsEntry>, for dayTime: DayTime) throws {
        savedEntries = entries
    }
    
    func saveEntry(_ entry: PromptsEntry) {
        savedEntries.insert(entry)
    }
    
    func delete(_ entry: PromptsEntry) {
        savedEntries.remove(entry)
    }
    
    
}
