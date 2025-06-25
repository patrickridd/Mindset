//
//  PromptsEntryContent.swift
//  Mindset
//
//  Created by patrick ridd on 6/24/25.
//

import Foundation

protocol PromptsEntryContent: Identifiable {
    var id: UUID { get }
    var dateCompleted: Date? { get set }
    var prompts: [any PromptContent] { get }
}
