//
//  PromptCompletionStep.swift
//  Mindset
//
//  Created by patrick ridd on 6/8/25.
//

import Foundation

protocol CoordinatedFlowCompletionStep: CoordinatedFlowStep {
    var id: String { get }
    var title: String { get }
    var subtitle: String { get }
}
