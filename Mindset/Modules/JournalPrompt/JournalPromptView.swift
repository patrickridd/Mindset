//
//  JournalEntryView.swift
//  Mindset
//
//  Created by patrick ridd on 6/1/25.
//

import SwiftUI

struct JournalPromptView: CoordinatableView {
    
    @StateObject private var viewModel: JournalPromptViewModel
    @FocusState private var isFocused: Bool

    let id: String

    init(viewModel: JournalPromptViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.id = UUID().uuidString
    }

    var body: some View {
        VStack(spacing: 16) {
            // Title
            VStack {
                HStack {
                    Text(viewModel.journalPrompt.title)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                // Subtitle
                HStack {
                    Text(viewModel.journalPrompt.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            .padding([.leading, .trailing, .top], 24)

            // Text Input Area
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(uiColor: .systemBackground)))
                    .frame(height: 180)

                TextEditor(text: $viewModel.journalPrompt.entryText)
                    .padding(12)
                    .frame(height: 180)
                    .background(Color.clear)
                    .cornerRadius(16)
                    .disabled(viewModel.submissionSuccess)
                    .focused($isFocused)
                    .onAppear {
                        isFocused = true
                    }
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
                    viewModel.submit()
                }) {
                    HStack {
                        Text(viewModel.buttonText)
                            .font(.headline)
                        if viewModel.submissionSuccess {
                            Image(systemName: "arrow.right.circle")
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.buttonBackgroundColor)
                    .cornerRadius(12)
                    .sensoryFeedback(viewModel.submissionSuccess ? .increase : .success, trigger: viewModel.flowCoordinator.stepsCompleted)
                }
                .disabled(viewModel.buttonDisabled)
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .background(viewModel.parentButtonBackgroundColor)
        }
        .animation(.bouncy, value: viewModel.submissionSuccess)
        .background(viewModel.bodyBackgroundColor)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    JournalPromptView(viewModel: .init(journalPrompt: JournalPrompt.goalSetting, flowCoordinator: JournalEntryFlowCoordinator(steps: [], onCompletion: {})))
}
