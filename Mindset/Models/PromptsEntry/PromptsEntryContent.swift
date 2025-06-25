//
//  PromptsEntryContent.swift
//  Mindset
//
//  Created by patrick ridd on 6/24/25.
//

import Foundation

protocol PromptsEntryContent: Identifiable, Codable {
    var id: UUID { get }
    var promptEntryDate: Date { get }
    var dateCompleted: Date? { get set }
    var prompts: [any PromptContent] { get }
}
