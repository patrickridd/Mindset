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
    let date: Date
    let dayTime: DayTime
    private(set) var completed: Bool = false

    init(id: UUID = UUID(), prompts: [any PromptContent], dayTime: DayTime) {
        self.id = id
        self.date = Date().startOfDay
        self.prompts = prompts
        self.dayTime = dayTime
    }

    mutating func setEntryCompleted() {
        completed = true
    }
}

extension PromptsEntry: Equatable {
    static func == (lhs: PromptsEntry, rhs: PromptsEntry) -> Bool {
        lhs.id == rhs.id
    }
}

extension PromptsEntry {
    enum CodingKeys: String, CodingKey {
        case id
        case promptEntryDate
        case prompts
        case completed
        case type
        case moodValue
    }

    struct AnyPromptContentWrapper: Codable {
        let prompt: any PromptContent

        enum CodingKeys: String, CodingKey {
            case type
            case value
        }

        init(prompt: any PromptContent) {
            self.prompt = prompt
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            // Handle only Prompt for now
            if let prompt = prompt as? Prompt {
                try container.encode("Prompt", forKey: .type)
                try container.encode(prompt, forKey: .value)
            } else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unknown PromptContent type")
                throw EncodingError.invalidValue(prompt, context)
            }
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
            switch type {
            case "Prompt":
                self.prompt = try container.decode(Prompt.self, forKey: .value)
            default:
                let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown PromptContent type: \(type)")
                throw DecodingError.typeMismatch((any PromptContent).self, context)
            }
        }
    }
}

extension PromptsEntry: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        let promptWrappers = prompts.map { AnyPromptContentWrapper(prompt: $0) }
        try container.encode(promptWrappers, forKey: .prompts)
        try container.encode(completed, forKey: .completed)
        try container.encode(date, forKey: .promptEntryDate)
        try container.encode(dayTime, forKey: .type)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        let promptWrappers = try container.decode([AnyPromptContentWrapper].self, forKey: .prompts)
        self.prompts = promptWrappers.map { $0.prompt }
        self.completed = try container.decodeIfPresent(Bool.self, forKey: .completed) ?? false
        self.date = try container.decode(Date.self, forKey: .promptEntryDate)
        self.dayTime = try container.decode(DayTime.self, forKey: .type)
    }
}

class Mocks {
    static var morningMindSet = PromptsEntry(prompts: DayTime.morning.defaultPrompts, dayTime: .morning)
    static var nightMindSet = PromptsEntry(prompts: DayTime.night.defaultPrompts, dayTime: .night)
}
