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
        VStack(spacing: 0) {
            topBar
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    VStack(spacing: 12) {
                        quoteView
                            .fontWeight(.light)
                            .padding(.leading, 2)
                    }
                    .animation(
                        .easeInOut(duration: 0.5),
                        value: viewModel.dayTime
                    )
                    VerticalProgressBarView(
                        todoCardItems: viewModel.todoCardItems,
                        currentStep: viewModel.currentStep
                    )
                }
            }
            .padding(.top)
        }
    }
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(
            coordinator: Coordinator(viewFactory: ViewFactory()),
            promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()),
            dayTime: .morning
        )
    )
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(
            coordinator: Coordinator(viewFactory: ViewFactory()),
            promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore()),
            dayTime: .night
        )
    )
}

extension HomeView {
    var topBar: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 8) {
                    navTitle
                    HStack {
                        DayTimePicker(
                            dayTime: $viewModel.dayTime
                        )
                        .padding(.leading, 3)
                        Spacer()
                        HStack(alignment: .top, spacing: 16) {
                            StreakTracker()
                            profileButton
                        }
                    }
                }
            }
            .padding(.top)
            .padding(.horizontal, 16)

//            Divider()
        }
    }

    var navTitle: some View {
        Text("Daily Mindset")
            .font(.title2)
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
    
    var quoteView: some View {
        Text("""
            “When you arise in the morning think of what a privilege it is to be alive, to think, to enjoy, to love ...”
            
            ― Marcus Aurelius, Meditations
            """
        )
        .padding([.horizontal], 24)
        .font(.caption)
        .italic()
        .foregroundStyle(.secondary)
    }
}
