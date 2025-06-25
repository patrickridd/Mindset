//
//  CalendarViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 5/20/25.
//

import Foundation

class CalendarWeekViewModel: ObservableObject {

    @Published var selectedDate: Date = Date()
    @Published var currentWeekIndex: Int = 0

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
        let endDate = calendar.date(byAdding: .day, value: daysRange, to: today) ?? today
        let weekday = calendar.component(.weekday, from: endDate)
        // weekday: 1 = Sunday, 7 = Saturday
        return calendar.date(byAdding: .day, value: 7 - weekday, to: endDate) ?? endDate
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

}
