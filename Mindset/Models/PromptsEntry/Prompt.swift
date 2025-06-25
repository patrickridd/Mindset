//
//  Prompt.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import Foundation

struct Prompt: PromptContent {

    let title: String
    let subtitle: String
    let id: String
    var date: Date
    var entryText: String
    var completed: Bool = false
}

extension Prompt {
    
    static var gratitude: Prompt {
        .init(
            title: "Gratitude",
            subtitle: "Reflect on one thing you are grateful for today.",
            id: UUID().uuidString,
            date: Date(),
            entryText: ""
        )
    }

    static var reflection: Prompt {
        .init(
            title: "Reflection",
            subtitle: "Take a moment to reflect on your day.",
            id: UUID().uuidString,
            date: Date(),
            entryText: ""
        )
    }

    static var selfTalk: Prompt {
        .init(
            title: "Self-Talk",
            subtitle: "Practice self-compassion by reflecting on your inner dialogue.",
            id: UUID().uuidString,
            date: Date(),
            entryText: ""
        )
    }

    static var affirmation: Prompt {
        .init(
            title: "Affirmation",
            subtitle: "Write down one affirmation to repeat to yourself today.",
            id: UUID().uuidString,
            date: Date(),
            entryText: ""
        )
    }

    static var goalSetting: Prompt {
        .init(
            title: "Goal Setting",
            subtitle: "Set one small goal for yourself today.",
            id: UUID().uuidString,
            date: Date(),
            entryText: ""
        )
    }
}
