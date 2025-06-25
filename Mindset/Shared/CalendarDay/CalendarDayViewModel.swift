//
//  CalendarDayViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 5/20/25.
//

import SwiftUI

class CalendarDayViewModel: ObservableObject {

    @Published var isSelectedDay: Bool

    private(set) var calendarDay: CalendarDay
    private(set) var parentViewModel: CalendarWeekViewModel
    private(set) var isDayCompleted: Bool

    private let today = Calendar.current.startOfDay(for: Date())
    private let calendar = Calendar.current

    init(calendarDay: CalendarDay, parentViewModel: CalendarWeekViewModel, isDayCompleted: Bool = false) {
        self.calendarDay = calendarDay
        self.parentViewModel = parentViewModel
        self.isDayCompleted = isDayCompleted
        self.isSelectedDay = calendar.isDate(calendarDay.date, inSameDayAs: parentViewModel.selectedDate)
    }

    var isCalendarDayInCurrentMonth: Bool {
        !calendarDay.isCurrentMonth
    }

    var calendarDayDigit: String {
        "\(calendar.component(.day, from: calendarDay.date))"
    }

    var circleColor: Color {
        if isCalendarDayToday {
            return .orange
        } else if isCalendarDayBeforeToday {
            return .gray.opacity(0.15)
        } else {
            return .gray.opacity(0.25)
        }
    }

    var circleBorderColor: Color {
        if isDayCompleted {
            return .green
        }
        return isSelectedDayCalendarDay ? .indigo : .clear
    }
    
    var isCalendarDayBeforeToday: Bool {
        calendar.startOfDay(for: calendarDay.date) < today
    }

    var isCalendarDayAfterToday: Bool {
        calendar.startOfDay(for: calendarDay.date) > today
    }

    var isCalendarDayToday: Bool {
        calendar.isDate(calendarDay.date, inSameDayAs: Date())
    }

    var digitTextColor: Color {
        if isSelectedDay {
            return .primary
        } else {
            return .primary.opacity(isCalendarDayBeforeToday ? 0.25 : 1)
        }
    }

    var dayOfWeekTextColor: Color {
        .primary.opacity(isCalendarDayBeforeToday ? 0.25 : 1)
    }

    var dayOfWeekFontWeight: Font.Weight {
        isCalendarDayToday ? .bold : .regular
    }

    var numberTextFontWeight: Font.Weight {
        isCalendarDayToday ? .bold: .regular
    }

    var isSelectedDayCalendarDay: Bool {
        calendar.isDate(calendarDay.date, equalTo: parentViewModel.selectedDate, toGranularity: .day)
    }

    var dayOfWeek: String {
        let weekday = calendar.component(.weekday, from: calendarDay.date)
        return Week.allCases[weekday - 1].abbreviation
    }

    var circleLineWidth: CGFloat {
        isDayCompleted ? 5 : 3
    }

    func dayTapped() {
        parentViewModel.selectedDate = calendarDay.date
        isSelectedDay = calendar.isDate(calendarDay.date, inSameDayAs: parentViewModel.selectedDate)
    }

}
