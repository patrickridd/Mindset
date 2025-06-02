import SwiftUI
import Combine

class JournalEntryViewModel: ObservableObject {
    @Published var journalText: String = ""
    @Published var submissionSuccess: Bool = false

    func submit() {
        guard !journalText.isEmpty else { return }
        submissionSuccess = true
    }

    func reset() {
        journalText = ""
        submissionSuccess = false
    }
} 