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
        colorScheme == .dark ? .night : .morning
    }
}

#Preview {
    MainTabView()
}
