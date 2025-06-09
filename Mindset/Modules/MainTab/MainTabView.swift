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
            HomeView(viewModel: HomeViewModel(coordinator: coordinator))
                .tabItem {
                    Label("", systemImage: "house")
                }
        }
    }
}

#Preview {
    MainTabView()
}
