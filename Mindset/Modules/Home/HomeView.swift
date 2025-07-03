//
//  HomeView.swift
//  Mindset
//
//  Created by patrick ridd on 6/26/25.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel, promptsEntryType: PromptsEntryType? = nil) {
        let initialType: PromptsEntryType
        #if DEBUG
        // colorScheme is only available at runtime, so use the provided promptsEntryType if any in preview
        if let providedType = promptsEntryType {
            initialType = providedType
        } else {
            initialType = .day
        }
        #else
        if let providedType = promptsEntryType {
            initialType = providedType
        } else {
            // Determine initial promptsEntryType based on colorScheme at runtime
            initialType = colorScheme == .dark ? .night : .day
        }
        #endif
        
        let updatedViewModel = HomeViewModel(
            coordinator: viewModel.coordinator,
            promptsEntryManager: viewModel.promptsEntryManager,
            promptsEntryType: initialType
        )
        
        self._viewModel = StateObject(wrappedValue: updatedViewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 8) {
                        Text("Good morning, Patrick!")
                            .font(.title)
                            .frame(width: UIScreen.main.bounds.width-48,
                                   alignment: .leading)
                        Text("Start your morning mindset here.")
                            .frame(width: UIScreen.main.bounds.width-48,
                                   alignment: .leading)
                            .padding(.leading, 2)
                    }
                    if let entry = viewModel.entry {
                        PromptsEntryCardView(viewModel: PromptsEntryCardViewModel(
                            entry: entry,
                            coordinator: viewModel.coordinator,
                            promptsEntryManager: viewModel.promptsEntryManager
                        ))
                        .padding(.top)
                    } else {
                        StartPromptsEntryCardView(viewModel: StartPromptsEntryCardViewModel(
                            coordinator: viewModel.coordinator,
                            promptsEntryManager: viewModel.promptsEntryManager,
                            promptsEntryType: viewModel.promptsEntryType
                        ))
                    }
                }
                .padding(.top, 25)
            }
        }
    }
}

#Preview {
    // Note: colorScheme is only available at runtime, so previews should test both light and dark if needed
    HomeView(
        viewModel: HomeViewModel(
            coordinator: Coordinator(),
            promptsEntryManager: PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore())
        ),
        promptsEntryType: nil
    )
}

extension HomeView {
    var topBar: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
//                    navTitle
                    promptsEntryTypePicker
                }
                Spacer()
                HStack(alignment: .top, spacing: 16) {
                    StreakTracker()
                    profileButton
                }
            }
            .padding(.top)
            .padding(.horizontal, 16)
            
            Divider()
        }
    }

    var promptsEntryTypePicker: some View {
        HStack(alignment: .center, spacing: 4) {
            ForEach(PromptsEntryType.allCases, id: \.self) { type in
                Button(action: {
                    viewModel.promptsEntryType = type
                }) {
                    Text(type.displayName)
                        .font(.title2)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 18)
                        .background(
                            viewModel.promptsEntryType == type ? Color.accentColor.opacity(colorScheme == .dark ? 0.4 : 0.18) : Color.clear
                        )
                        .foregroundStyle(viewModel.promptsEntryType == type ? Color.accentColor : Color.primary)
                        .clipShape(Capsule())
                        .animation(
                            .easeInOut(duration: 0.18),
                            value: viewModel.promptsEntryType
                        )
                }
                .buttonStyle(.plain)
            }
        }
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

extension PromptsEntryType {
    var displayName: String {
        switch self {
        case .day: return "☀️"
        case .night: return "🌙"
        }
    }
}
