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
        if isSelectedDay {
            return .blue
        } else if isBeforeSelectedDate {
            return .gray.opacity(0.15)
        } else {
            return .purple
        }
    }

    var textColor: Color {
        if isSelectedDay {
            return .white
        } else {
            return .black
        }
    }
    
    
    func dayTapped() {
        parentViewModel.selectedDate = calendarDay.date
    }
    
    func dayOfWeek() -> String {
        let date = calendarDay.date
        let weekday = calendar.component(.weekday, from: date)
        return Week.allCases[weekday - 1].abbreviation
    }
    
    var isBeforeSelectedDate: Bool {
        calendarDay.date < parentViewModel.selectedDate
    }

    var isAfterSelectedDate: Bool {
        calendarDay.date > parentViewModel.selectedDate
    }
}
