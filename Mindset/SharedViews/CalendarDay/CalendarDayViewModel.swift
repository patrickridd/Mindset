//
//  CalendarDayViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 5/20/25.
//

import SwiftUI

class CalendarDayViewModel: ObservableObject {

    private(set) var calendarDay: CalendarDay
    private(set) var parentViewModel: CalendarViewModel
    
    private let today = Calendar.current.startOfDay(for: Date())
    private let calendar = Calendar.current
    
    init(calendarDay: CalendarDay, parentViewModel: CalendarViewModel) {
        self.calendarDay = calendarDay
        self.parentViewModel = parentViewModel
    }

    var isSelectedDay: Bool {
        calendar.isDate(calendarDay.date, inSameDayAs: parentViewModel.selectedDate)
    }

    var isCalendarDayInCurrentMonth: Bool {
        !calendarDay.isCurrentMonth
    }

    var calendarDayString: String {
        "\(calendar.component(.day, from: calendarDay.date))"
    }

    var circleColor: Color {
        if isCalendarDayToday {
            return .yellow
        } else if isCalendarDayBeforeToday {
            return .gray.opacity(0.15)
        } else {
            return .gray.opacity(0.25)
        }
    }

    var circleBorderColor: Color {
        isSelectedDayCalendarDay ? .blue : .clear
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

    var textColor: Color {
       if isCalendarDayBeforeToday {
            return .black.opacity(0.25)
        } else {
            return .black
        }
    }

    var dayOfWeekFontWeight: Font.Weight {
        isCalendarDayToday ? .bold : .regular
    }

    var numberTextFontWeight: Font.Weight {
        isCalendarDayToday ? .medium: .regular
    }

    var isSelectedDayCalendarDay: Bool {
        calendar.isDate(calendarDay.date, equalTo: parentViewModel.selectedDate, toGranularity: .day)
    }

    var dayOfWeek: String {
        let weekday = calendar.component(.weekday, from: calendarDay.date)
        return Week.allCases[weekday - 1].abbreviation
    }

    func dayTapped() {
        parentViewModel.selectedDate = calendarDay.date
    }

}
