//
//  MainTabView.swift
//  Mindset
//
//  Created by patrick ridd on 4/29/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CheckInView()
                .tabItem {
                    Label("Home", systemImage: "leaf.fill")
                }
            TrackerView()
                .tabItem {
                    Label("Tracker", systemImage: "chart.bar.fill")
                }
            ToolboxView()
                .tabItem {
                    Label("Toolbox", systemImage: "heart.text.square.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    MainTabView()
}
