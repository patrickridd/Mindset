//
//  HomeView.swift
//  Mindset
//
//  Created by patrick ridd on 6/26/25.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            topBar
                .padding(.top)
            ScrollView {
                Spacer()
                if let entry = viewModel.entry {
                    PromptEntryCardView(viewModel: PromptEntryCardViewModel(
                        entry: entry,
                        coordinator: viewModel.coordinator,
                        promptsEntryManager: viewModel.promptsEntryManager
                    ))
                    Spacer()
                } else {
                    journalButton
                }
                Spacer()
            }
            .scrollBounceBehavior(.always)
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(coordinator: Coordinator(), promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore())))
}

extension HomeView {
    var topBar: some View {
        HStack(alignment: .center) {
            navTitle
            Spacer()
            HStack(spacing: 16) {
                StreakTracker()
                profileButton
            }
        }
        .padding(.horizontal, 16)
    }

    var navTitle: some View {
        Text("Daily Mindset")
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity,
                   alignment: .leading)
    }

    var profileButton: some View {
        Button {
            
        } label: {
           Image(systemName: "person.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.indigo)
        }
    }

    var buttonTitle: some View {
        Text("Tap to begin")
            .font(.headline)
            .foregroundStyle(.orange)
    }
    
    var journalButton: some View {
        Button(action: {
            viewModel.journalButtonTapped()
        }) {
            VStack(spacing: 12) {
                Image(systemName: "square.and.pencil.circle.fill")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(.indigo)
                buttonTitle
            }
            .padding(.top, 150)
            .sensoryFeedback(.selection, trigger: viewModel.presentingPromptChainFlow)
        }
    }

    func entryView(for entry: PromptsEntry) -> some View {
        Button(action: viewModel.journalButtonTapped) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Journal for \(entry.promptEntryDate.formatted(date: .long, time: .omitted))")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.orange)
                    Spacer()
                    Button(action: viewModel.deleteButtonTapped) {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
                ForEach(entry.prompts.indices, id: \.self) { i in
                    // Customize based on actual PromptContent type
                    HStack {
                        Text("• \(entry.prompts[i].title):")
                            .font(.subheadline)
                        Text(String(describing: entry.prompts[i].entryText))
                            .font(.headline)
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .animation(.easeInOut, value: viewModel.entry == nil)
            .padding(.horizontal, 24)
        }
    }
}
