//
//  PromptCompletionStep.swift
//  Mindset
//
//  Created by patrick ridd on 6/8/25.
//

import Foundation

struct PromptCompletionStep: CoordinatedFlowCompletionStep {
    let id: String = UUID().uuidString
    let title: String = "You did it! ✅"
    let subtitle: String = "Way to take time for yourself today 🎉"  
}
