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
                    PromptsEntryCardView(viewModel: PromptsEntryCardViewModel(
                        entry: entry,
                        coordinator: viewModel.coordinator,
                        promptsEntryManager: viewModel.promptsEntryManager
                    ))
                    Spacer()
                } else {
                    StartPromptsEntryCardView(viewModel: .init(coordinator: viewModel.coordinator, promptsEntryManager: viewModel.promptsEntryManager))
                        .padding(.top, 12)

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
}
