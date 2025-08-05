//
//  ProfileView.swift
//  Mindset
//
//  Created by patrick ridd on 8/3/25.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel
    
    @State private var name: String = ""
//    @State private var focusArea: String = "Resilience"
//    @State private var localDataOnly = true

    let focusOptions = [
        "Resilience", "Stress Relief", "Emotional Clarity", "Focus", "Self-Compassion"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Info")) {
                    TextField("First Name or Nickname", text: $viewModel.name)
//                    Picker("Focus Area", selection: $focusArea) {
//                        ForEach(focusOptions, id: \.self) { option in
//                            Text(option)
//                        }
//                    }
                }

                Section(header: Text("Preferences")) {
                    Toggle("Enable Reminders", isOn: $viewModel.notificationsEnabled)
//                    Toggle("Store data locally only", isOn: $localDataOnly)
                }

                Section {
                    Button(role: .destructive) {
                        // Add logic for clearing local data
                    } label: {
                        Text("Clear My Data")
                    }
                    Button(role: .destructive) {
                        // Add logic for deleting profile
                    } label: {
                        Text("Delete Profile")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
}
