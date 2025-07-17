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
    let promptEntryDate: Date
    var dateCompleted: Date? = nil
    var moodValue: Double? = nil
    var type: DayTime

    init(id: UUID = UUID(), promptEntryDate: Date, prompts: [any PromptContent], type: DayTime, moodValue: Double? = nil) {
        self.id = id
        self.promptEntryDate = promptEntryDate
        self.prompts = prompts
        self.type = type
        self.moodValue = moodValue
    }

    mutating func set(completionDate: Date) {
        dateCompleted = completionDate
    }
}

extension PromptsEntry: Equatable {
    static func == (lhs: PromptsEntry, rhs: PromptsEntry) -> Bool {
        lhs.id == rhs.id && lhs.moodValue == rhs.moodValue
    }
}

extension PromptsEntry {
    enum CodingKeys: String, CodingKey {
        case id
        case promptEntryDate
        case prompts
        case dateCompleted
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
        try container.encode(dateCompleted, forKey: .dateCompleted)
        try container.encode(promptEntryDate, forKey: .promptEntryDate)
        try container.encode(type, forKey: .type)
        try container.encode(moodValue, forKey: .moodValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        let promptWrappers = try container.decode([AnyPromptContentWrapper].self, forKey: .prompts)
        self.prompts = promptWrappers.map { $0.prompt }
        self.dateCompleted = try container.decodeIfPresent(Date.self, forKey: .dateCompleted)
        self.promptEntryDate = try container.decode(Date.self, forKey: .promptEntryDate)
        self.type = try container.decode(DayTime.self, forKey: .type)
        self.moodValue = try container.decodeIfPresent(Double.self, forKey: .moodValue)
    }
}

class Mocks {
    static var morningMindSet = PromptsEntry(promptEntryDate: .today, prompts: DayTime.morning.defaultPrompts, type: .morning)
    static var nightMindSet = PromptsEntry(promptEntryDate: .today, prompts: DayTime.night.defaultPrompts, type: .night)
}
