//
//  PromptViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/1/25.
//

import SwiftUI
import Combine
import AVFoundation

@MainActor
class PromptViewModel: ObservableObject {

    @Published var journalPrompt: any PromptContent
    @Published var submissionSuccess: Bool = false
    @Published var flowCoordinator: (any FlowCoordinator)
    
    private let soundPlayer = SoundPlayer()

    init(journalPrompt: any PromptContent, flowCoordinator: any FlowCoordinator) {
        self.journalPrompt = journalPrompt
        self.flowCoordinator = flowCoordinator
    }
    
    func submit() {
        guard !journalPrompt.entryText.isEmpty else { return }

        if submissionSuccess {
            flowCoordinator.next()
            return
        }

        submissionSuccess = true
        soundPlayer.stepComplete()
        journalPrompt.completed = true
        flowCoordinator.completeStep()
    }

    func reset() {
        journalPrompt.entryText = ""
        submissionSuccess = false
    }

    var buttonText: String {
        submissionSuccess ? "CONTINUE" : "LET'S GO!"
    }

    var buttonBackgroundColor: Color {
        submissionSuccess ? Color.green : (journalPrompt.entryText.isEmpty ? Color.gray : Color.green)
    }

    var parentButtonBackgroundColor: Color {
        submissionSuccess ? Color.green.opacity(0.15): .clear
    }

    var buttonDisabled: Bool {
        journalPrompt.entryText.isEmpty && !submissionSuccess
    }
    
    var bodyBackgroundColor: Color {
        submissionSuccess ? .green.opacity(0.1) : Color.gray.opacity(0.15)
    }
}
