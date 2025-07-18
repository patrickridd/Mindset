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
}
