//
//  MockPromptsEntryFileStore.swift
//  MindsetTests
//
//  Created by patrick ridd on 7/17/25.
//

import Foundation
@testable import Mindset

struct MockPromptsEntryFileStore: PromptsEntryPersistence {
    

    func fileURL(path: String) -> URL {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return URL(fileURLWithPath: path, relativeTo: cacheURL)
    }

    func loadPrompts(for dayTime: Mindset.DayTime) -> [Mindset.PromptsEntry] {
        []
    }
    
    func saveEntries(_ entries: [Mindset.PromptsEntry], for dayTime: Mindset.DayTime) throws {
    }
    
    func saveEntry(_ entry: Mindset.PromptsEntry) {
    }
    
    func delete(_ entry: Mindset.PromptsEntry) {
    }
    
    
}
