//
//  TrackerView.swift
//  Mindset
//
//  Created by patrick ridd on 5/1/25.
//

import SwiftUI

import SwiftUI
import Charts  // Requires iOS 16+ and import Charts

struct MoodEntry: Identifiable {
    let id = UUID()
    let date: Date
    let moodValue: Int  // 1 (low) to 5 (high)
}

struct TrackerView: View {
    // Sample data for preview
    let moodData: [MoodEntry] = [
        MoodEntry(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, moodValue: 2),
        MoodEntry(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, moodValue: 3),
        MoodEntry(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, moodValue: 3),
        MoodEntry(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, moodValue: 4),
        MoodEntry(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, moodValue: 5),
        MoodEntry(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, moodValue: 4),
        MoodEntry(date: Date(), moodValue: 5),
    ]
    
    let currentStreak = 7
    let resiliencePoints = 42

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("📅 Current Streak: \(currentStreak) days")
                    .font(.headline)

                Text("💪 Resilience Points: \(resiliencePoints)")
                    .font(.subheadline)

                Text("Mood Trend (Past 7 Days)")
                    .font(.headline)

                Chart {
                    ForEach(moodData) { entry in
                        LineMark(
                            x: .value("Day", entry.date),
                            y: .value("Mood", entry.moodValue)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.blue)
                    }
                }
                .frame(height: 200)

                Divider()

                Text("🌱 Your Growth")
                    .font(.headline)
                Text("Your mental garden is growing. Keep showing up.")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                // Placeholder for future growth visual
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
                    .frame(height: 100)
                    .overlay(Text("🌿 (Plant animation placeholder)").foregroundColor(.blue))
            }
            .padding()
        }
        .navigationTitle("Tracker")
    }
}

#Preview {
    TrackerView()
}
