//
//  JournalEntryView.swift
//  Mindset
//
//  Created by patrick ridd on 6/1/25.
//

import SwiftUI

struct JournalEntryView: View {
    @State private var journalText: String = ""
    @State private var submissionSuccess: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            // Title
            HStack {
                Text("Journal Entry")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding([.top, .leading], 24)
            
            // Text Input Area
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                    .frame(height: 180)
                
                TextEditor(text: $journalText)
                    .padding(12)
                    .frame(height: 180)
                    .background(Color.clear)
                    .cornerRadius(16)
                    .disabled(submissionSuccess)
                // Optional: lock editing after submit
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Success Feedback Area
            
            VStack(spacing: 0) {
                if submissionSuccess {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Great!")
                            .font(.headline)
                            .foregroundColor(.green)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .padding()
                }
                // Button
                Button(action: {
                    if submissionSuccess {
                        // Handle continue action (e.g., clear, dismiss, etc.)
                        journalText = ""
                        submissionSuccess = false
                    } else {
                        // Handle check action
                        submissionSuccess = true
                    }
                }) {
                    HStack {
                        if submissionSuccess {
                            Image(systemName: "checkmark")
                        }
                        Text(submissionSuccess ? "CONTINUE" : "CHECK")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(submissionSuccess ? Color.green : (journalText.isEmpty ? Color.gray : Color.green))
                    .cornerRadius(12)
                }
                .disabled(journalText.isEmpty && !submissionSuccess)
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .background(submissionSuccess ? Color.green.opacity(0.15): .clear)

        }
        .background(Color.gray.opacity(0.15))
    }
}


#Preview {
    JournalEntryView()
}
