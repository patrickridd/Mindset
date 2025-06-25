//
//  PromptContent.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import Foundation

protocol PromptContent: CoordinatedFlowStep {
    var id: String { get }
    var title: String { get }
    var subtitle: String { get }
    var date: Date { get set }
    var entryText: String { get set }
    var completed: Bool { get set }
}
