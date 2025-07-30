//
//  PromptsEntryContent.swift
//  Mindset
//
//  Created by patrick ridd on 6/24/25.
//

import Foundation

protocol PromptsEntryContent: Identifiable, Codable, ObservableObject {
    var id: UUID { get }
    var dayTime: DayTime { get }
    var date: Date { get }
    var completed: Bool { get }
    var prompts: [any PromptContent] { get }
}
