//
//  MockPromptsEntryManager.swift
//  MindsetTests
//
//  Created by patrick ridd on 7/17/25.
//

import Foundation
@testable import Mindset

class MockPromptsEntryManager: PromptsEntryManager {
 
    init() {
        super.init(promptsEntryPersistence: MockPromptsEntryFileStore())
    }

    override func save(entry: PromptsEntry) {
        switch entry.dayTime {
        case .morning:
            self.morningEntries.insert(entry)
        case .night:
            self.nightEntries.insert(entry)
        }
    }
    
    override func getPromptsEntry(for date: Date, dayTime: DayTime) -> PromptsEntry? {
        switch dayTime {
        case .morning:
            return self.morningEntries.first { $0.date.inSameDayAs(date: date) }
        case .night:
            return self.nightEntries.first { $0.date.inSameDayAs(date: date) }
        }
    }
}
