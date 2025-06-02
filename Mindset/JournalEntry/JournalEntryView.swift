//
//  JournalEntryView.swift
//  Mindset
//
//  Created by patrick ridd on 6/1/25.
//

import SwiftUI

struct JournalEntryView: View {

    @StateObject private var viewModel = JournalEntryViewModel()

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
                
                TextEditor(text: $viewModel.journalText)
                    .padding(12)
                    .frame(height: 180)
                    .background(Color.clear)
                    .cornerRadius(16)
                    .disabled(viewModel.submissionSuccess)
                // Optional: lock editing after submit
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Success Feedback Area
            
            VStack(spacing: 0) {
                if viewModel.submissionSuccess {
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
                    if viewModel.submissionSuccess {
                        // Handle continue action (e.g., clear, dismiss, etc.)
                        viewModel.journalText = ""
                        viewModel.submissionSuccess = false
                    } else {
                        // Handle check action
                        viewModel.submissionSuccess = true
                    }
                }) {
                    HStack {
                        Text(viewModel.submissionSuccess ? "CONTINUE" : "CHECK")
                            .font(.headline)
                        if viewModel.submissionSuccess {
                            Image(systemName: "arrow.right.circle")
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.submissionSuccess ? Color.green : (viewModel.journalText.isEmpty ? Color.gray : Color.green))
                    .cornerRadius(12)
                }
                .disabled(viewModel.journalText.isEmpty && !viewModel.submissionSuccess)
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .background(viewModel.submissionSuccess ? Color.green.opacity(0.15): .clear)

        }
        .animation(.bouncy, value: viewModel.submissionSuccess)
        .background(Color.gray.opacity(0.15))
    }
}


#Preview {
    JournalEntryView()
}
