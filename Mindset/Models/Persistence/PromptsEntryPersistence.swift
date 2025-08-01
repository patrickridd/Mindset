//
//  PromptsEntryPersistence.swift
//  Mindset
//
//  Created by patrick ridd on 6/25/25.
//

import Foundation

protocol PromptsEntryPersistence {
    func loadPrompts(for dayTime: DayTime) -> Set<PromptsEntry>
    func saveEntries(_ entries: Set<PromptsEntry>, for dayTime: DayTime) throws
    func saveEntry(_ entry: PromptsEntry)
    func delete(_ entry: PromptsEntry)
    func fileURL(path: String) -> URL
}
