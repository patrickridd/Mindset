//
//  JournalPromptViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/1/25.
//

import SwiftUI
import Combine

class JournalPromptViewModel: ObservableObject {
    @Published var journalPrompt: JournalPrompt
    @Published var submissionSuccess: Bool = false

    init(journalPrompt: JournalPrompt) {
        self.journalPrompt = journalPrompt
    }
    
    func submit() {
        guard !journalPrompt.entryText.isEmpty else { return }
        submissionSuccess = true
        journalPrompt.completed = true
    }

    func reset() {
        journalPrompt.entryText = ""
        submissionSuccess = false
    }

    var buttonText: String {
        submissionSuccess ? "CONTINUE" : "CHECK"
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
