//
//  MainTabView.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        TabView {
            coordinator.build(
                .homeView(promptsEntryManager: PromptsEntryManager(
                    promptsEntryPersistence: PromptsEntryFileStore()
                ))
            )
            .tabItem {
                Label("", systemImage: "brain.filled.head.profile")
            }
            coordinator.build(
                .trackerView(promptsEntryManager: PromptsEntryManager(
                    promptsEntryPersistence: PromptsEntryFileStore())
                )
            )
            .tabItem {
                Label("", systemImage: "chart.bar.xaxis.ascending")
            }
        }
        .tint(.indigo)
    }
}

#Preview {
    MainTabView()
}
