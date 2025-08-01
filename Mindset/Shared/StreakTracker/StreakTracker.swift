//
//  StreakTracker.swift
//  Mindset
//
//  Created by patrick ridd on 6/16/25.
//

import SwiftUI

struct StreakTracker: View {
    
    @State var allJournalEntries: [PromptsEntry] = []
    
    var currentStreak: Int {
        // Get all dates with a completed entry
        let completedEntries = allJournalEntries.filter { $0.completed }
        let completedDates = completedEntries.compactMap { $0.date.startOfDay }.sorted(by: >)
        guard !completedDates.isEmpty else { return 0 }
        
        var streak = 0
        
        var currentDate = Date().startOfDay
        for date in completedDates {
            if Calendar.current.isDate(date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if date < currentDate { // broke streak
                break
            }
        }
        return streak
    }
    
    var body: some View {
        Button {
            
        } label: {
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text("\(currentStreak)")
                    .font(.headline)
                    .foregroundColor(.orange)
                    .bold()
            }
            .frame(alignment: .leading)
            .accessibilityLabel("Current streak: \(currentStreak) days")
        }
    }
}

#Preview {
    StreakTracker()
}
