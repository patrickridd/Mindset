import SwiftUI
import Combine

class JournalEntryViewModel: ObservableObject {
    @Published var journalEntry: JournalEntry
    @Published var submissionSuccess: Bool = false

    init(journalEntry: JournalEntry) {
        self.journalEntry = journalEntry
    }
    
    func submit() {
        guard !journalEntry.entryText.isEmpty else { return }
        submissionSuccess = true
    }

    func reset() {
        journalEntry.entryText = ""
        submissionSuccess = false
    }

    var buttonText: String {
        submissionSuccess ? "CONTINUE" : "CHECK"
    }

    var buttonBackgroundColor: Color {
        submissionSuccess ? Color.green : (journalEntry.entryText.isEmpty ? Color.gray : Color.green)
    }

    var parentButtonBackgroundColor: Color {
        submissionSuccess ? Color.green.opacity(0.15): .clear
    }

    var buttonDisabled: Bool {
        journalEntry.entryText.isEmpty && !submissionSuccess
    }
}
