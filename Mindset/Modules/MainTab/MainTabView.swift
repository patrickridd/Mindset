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
                .homeView(promptsEntryPersistence: PromptsEntryFileStore())
            )
//                .tabItem {
//                    Label("", systemImage: "brain.filled.head.profile")
//                }
        }
        .tint(.indigo)

    }
}

#Preview {
    MainTabView()
}
