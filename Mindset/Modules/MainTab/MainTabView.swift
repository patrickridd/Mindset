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

    var body: some View {
        TabView {
            coordinator.build(
                .homeView(promptsEntryManager: promptsEntryManager)
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
}

#Preview {
    MainTabView()
}
