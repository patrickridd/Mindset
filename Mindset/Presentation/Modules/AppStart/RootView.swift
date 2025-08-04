//
//  CoordinatorView.swift
//  Mindset
//
//  Created by patrick ridd on 6/4/25.
//

import SwiftUI

struct RootView: View {

    @StateObject var coordinator: Coordinator = Coordinator(viewFactory: ViewFactory())
    @StateObject var promptEntryManager: PromptsEntryManager = PromptsEntryManager(promptsEntryPersistence: PromptsEntryFileStore())

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MainTabView()
                .navigationDestination(for: CoordinatedView.self) { screen in
                    coordinator.build(screen)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                    coordinator.build(fullScreenCover)
                }
        }
        .environmentObject(coordinator)
        .environmentObject(promptEntryManager)
    }
}

#Preview {
    RootView(coordinator: Coordinator(viewFactory: ViewFactory()))
}
