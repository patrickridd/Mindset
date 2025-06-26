//
//  CalendarViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 5/20/25.
//

import SwiftUI

@MainActor
class CalendarWeekViewModel: ObservableObject {

    @Binding var selectedDate: Date
    @Published var currentWeekIndex: Int = 0

    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
    }

    let calendar = Calendar.current
    let daysRange: Int = 30 // Days before and after today

    var alignedStartDate: Date {
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -daysRange, to: today) ?? today
        let weekday = calendar.component(.weekday, from: startDate)
        // weekday: 1 = Sunday, 2 = Monday, ..., 7 = Saturday
        return calendar.date(byAdding: .day, value: -(weekday - 1), to: startDate) ?? startDate
    }

    var alignedEndDate: Date {
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        // Align to the end of the current week (Saturday)
        return calendar.date(byAdding: .day, value: 7 - weekday, to: today) ?? today
    }

    var allDates: [CalendarDay] {
        var dates: [CalendarDay] = []
        var date = alignedStartDate
        while date <= alignedEndDate {
            let isCurrentMonth = calendar.isDate(date, equalTo: selectedDate, toGranularity: .month)
            dates.append(CalendarDay(date: date, isCurrentMonth: isCurrentMonth))
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }
        return dates
    }

    var weeks: [[CalendarDay]] {
        stride(from: 0, to: allDates.count, by: 7).map {
            Array(allDates[$0..<min($0 + 7, allDates.count)])
        }
    }

    var monthString: String {
        guard weeks.indices.contains(currentWeekIndex) else { return "" }
        let week = weeks[currentWeekIndex]
        guard let first = week.first?.date, let last = week.last?.date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let firstMonth = formatter.string(from: first).uppercased()
        let lastMonth = formatter.string(from: last).uppercased()
        let firstYear = yearFormatter.string(from: first)
        let lastYear = yearFormatter.string(from: last)
        let currentYear = yearFormatter.string(from: Date())
        if firstMonth == lastMonth && firstYear == lastYear {
            return firstYear == currentYear ? "\(firstMonth)" : "\(firstMonth) \(firstYear)"
        } else if firstYear == lastYear {
            return firstYear == currentYear ? "\(firstMonth) – \(lastMonth)" : "\(firstMonth) – \(lastMonth) \(firstYear)"
        } else {
            return "\(firstMonth) \(firstYear) – \(lastMonth) \(lastYear)"
        }
    }

    func selectedDate(is calendarDay: CalendarDay) -> Bool {
        calendar.isDate(selectedDate, inSameDayAs: calendarDay.date)
    }

    func selectedDayDidChange() {
        // Update week index if selectedDate changes
        if let selectedIndex = allDates.firstIndex(where: {
            calendar.isDate($0.date, inSameDayAs: selectedDate)
        }) {
            currentWeekIndex = selectedIndex / 7
            currentWeekIndex = min(max(currentWeekIndex, 0), weeks.count - 1)
        }
    }

    func viewDidAppear() {
        // Set initial week index to the week containing today
        if let todayIndex = allDates.firstIndex(where: {
            calendar.isDate($0.date, inSameDayAs: selectedDate)
        }) {
            currentWeekIndex = todayIndex / 7
            currentWeekIndex = min(max(currentWeekIndex, 0), weeks.count - 1)
        }
    }
}
