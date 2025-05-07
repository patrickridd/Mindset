//
//  ToolboxView.swift
//  Mindset
//
//  Created by patrick ridd on 5/1/25.
//

import SwiftUI

import SwiftUI

struct ToolboxView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Mind Reset Tools")) {
                    NavigationLink(destination: BreathingView()) {
                        Label("Breathing Exercise", systemImage: "wind")
                    }

                    NavigationLink(destination: ReframeView()) {
                        Label("Reframe a Thought", systemImage: "brain.head.profile")
                    }

                    NavigationLink(destination: BodyScanView()) {
                        Label("Body Scan", systemImage: "figure.walk.motion")
                    }
                }
            }
            .navigationTitle("Toolbox")
        }
    }
}

// Placeholder screens
struct BreathingView: View {
    var body: some View {
        Text("🫁 Guided Breathing Exercise")
            .font(.title2)
    }
}

struct ReframeView: View {
    var body: some View {
        Text("💭 Reframing Prompt")
            .font(.title2)
    }
}

struct BodyScanView: View {
    var body: some View {
        Text("🧘 Body Awareness Scan")
            .font(.title2)
    }
}

#Preview {
    ToolboxView()
}
