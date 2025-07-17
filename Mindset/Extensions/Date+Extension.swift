//
//  Date+Extension.swift
//  Mindset
//
//  Created by patrick ridd on 7/16/25.
//

import Foundation

extension Date {
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }
    var endOfDay: Date { startOfDay.addingTimeInterval(60*60*24 - 1) }
    
    static var today: Date {
        Date()
    }

    static var startOfToday: Date {
        today.startOfDay
    }

    static var endOfToday: Date {
        today.endOfDay
    }
}
