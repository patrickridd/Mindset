//
//  ContentView.swift
//  Mindset
//
//  Created by patrick ridd on 3/30/24.
//

import SwiftUI

struct CheckInView: View {
    @State private var selectedMood: String = ""
    @State private var gratitudeText: String = ""
    @State private var reflectionText: String = ""
    @State private var didSubmit = false

    let moods = ["😌", "😊", "😐", "😟", "😔"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("How are you feeling today?")
                    .font(.headline)
                HStack {
                    ForEach(moods, id: \.self) { mood in
                        Text(mood)
                            .font(.largeTitle)
                            .padding()
                            .background(selectedMood == mood ? Color.blue.opacity(0.2) : Color.clear)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedMood = mood
                            }
                    }
                }

                VStack(alignment: .leading) {
                    Text("What’s one thing you’re grateful for?")
                        .font(.subheadline)
                    TextField("e.g. Morning coffee ☕️", text: $gratitudeText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                VStack(alignment: .leading) {
                    Text("Optional: Any reflections?")
                        .font(.subheadline)
                    TextField("Share a quick thought...", text: $reflectionText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Button(action: {
                    didSubmit = true
                    // Add logic to save check-in to local store or backend
                }) {
                    Text("Complete Check-In")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(gratitudeText.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(gratitudeText.isEmpty)

                if didSubmit {
                    Text("✅ Resilience point earned!")
                        .foregroundColor(.green)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Daily Check-In")
        }
    }
}

#Preview {
    CheckInView()
}
