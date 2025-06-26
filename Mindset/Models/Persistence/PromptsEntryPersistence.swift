//
//  PromptsEntryPersistence.swift
//  Mindset
//
//  Created by patrick ridd on 6/25/25.
//

import Foundation

protocol PromptsEntryPersistence {
    func load() -> [PromptsEntry]
    func save(_ entries: [PromptsEntry])
    func add(_ entry: PromptsEntry)
    func delete(_ entry: PromptsEntry) 
}
