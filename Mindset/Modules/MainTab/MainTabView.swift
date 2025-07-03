//
//  MainTabView.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var promptsEntryManager: PromptsEntryManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        TabView {
            coordinator.build(
                .homeView(
                    promptsEntryManager: promptsEntryManager,
                    dayTime: getDayTime
                )
            )
            .tabItem {
                Label("", systemImage: "brain.filled.head.profile")
            }
            coordinator.build(
                .trackerView(promptsEntryManager: promptsEntryManager)
            )
            .tabItem {
                Label("", systemImage: "chart.bar.xaxis.ascending")
            }
        }
        .tint(.indigo)
    }
    
    var getDayTime: DayTime {
        let initialType: DayTime
        #if DEBUG
        // colorScheme is only available at runtime, so use the provided promptsEntryType if any in preview
        initialType = .morning
        #else
        if let providedType = promptsEntryType {
            initialType = providedType
        } else {
            // Determine initial promptsEntryType based on colorScheme at runtime
            initialType = colorScheme == .dark ? .night : .day
        }
        #endif
        return initialType
    }
}

#Preview {
    MainTabView()
}
