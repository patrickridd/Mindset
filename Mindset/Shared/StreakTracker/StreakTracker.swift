//
//  StreakTracker.swift
//  Mindset
//
//  Created by patrick ridd on 6/16/25.
//

import SwiftUI

extension Date {
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }
}

struct StreakTracker: View {
    
    @State var allJournalEntries: [JournalEntry] = []
    
    var currentStreak: Int {
        // Get all dates with a completed entry
        let completedDates = allJournalEntries.compactMap { $0.dateCompleted?.startOfDay }.sorted(by: >)
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
        HStack {
            Image(systemName: "flame.fill")
                .foregroundColor(.orange)
            Text("\(currentStreak)-day streak")
                .font(.headline)
                .foregroundColor(.orange)
                .bold()
        }
        .padding(.top, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityLabel("Current streak: \(currentStreak) days")
    }
}

#Preview {
    StreakTracker()
}
