//
//  MainTabView.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("", systemImage: "house")
                }
        }
    }
}

#Preview {
    MainTabView()
}
