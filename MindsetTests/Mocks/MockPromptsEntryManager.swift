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
            self.morningEntries[entry.date] = entry
        case .night:
            self.nightEntries[entry.date] = entry
        }
    }
    
    override func promptEntry(for date: Date, dayTime: DayTime) -> PromptsEntry? {
        switch dayTime {
        case .morning:
            return self.morningEntries[date]
        case .night:
            return self.nightEntries[date]
        }
    }
}
