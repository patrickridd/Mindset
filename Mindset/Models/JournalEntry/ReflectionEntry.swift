//
//  ReflectionEntry.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import Foundation

struct ReflectionEntry: JournalEntry {
    let title: String = "Reflection"
    let subtitle: String = "What would make today amazing and what can I do to make it happen?"
    var entryText: String = ""
    var date: Date = Date()
}
