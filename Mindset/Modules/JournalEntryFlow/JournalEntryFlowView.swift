//
//  JournalEntryFlowView.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

struct JournalEntryFlowView: View {

    @StateObject var viewModel: JournalEntryFlowViewModel = JournalEntryFlowViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
           topBarView
                .padding(.horizontal)
            NavigationStack {
                JournalPromptView(viewModel: .init(journalPrompt: viewModel.journalEntry.journalPrompts.first!))
            }
        }

    }
}

#Preview {
    JournalEntryFlowView()
}

extension JournalEntryFlowView {
    var topBarView: some View {
        HStack {
            Button {
                dismiss.callAsFunction()
            } label: {
                Image(systemName: "x.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            ProgressBarView(progress: viewModel.journalPromptProgressValue)
            Button {
                
            } label: {
                Text("😎")
                    .font(.largeTitle)
            }
        }
    }
}
