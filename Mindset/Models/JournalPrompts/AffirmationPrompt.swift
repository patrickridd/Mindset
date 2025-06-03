//
//  AffirmationEntry.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import Foundation

struct AffirmationPrompt: JournalPrompt {
    let title: String = "Affirmation"
    let subtitle: String = "Write down 1 affirmation to repeat daily."
    var entryText: String = ""
    var date: Date = Date()
    var completed: Bool = false
}
