//
//  DailyPromptsEntry.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import Foundation

struct PromptsEntry: PromptsEntryContent {
    let id: UUID
    let prompts: [any PromptContent]
    var dateCompleted: Date? = nil

    init(id: UUID = UUID(), prompts: [any PromptContent]) {
        self.id = id
        self.prompts = prompts
    }
}
