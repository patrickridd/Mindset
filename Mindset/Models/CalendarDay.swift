//
//  CalendarDay.swift
//  Mindset
//
//  Created by patrick ridd on 5/21/25.
//

import Foundation

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let isCurrentMonth: Bool
}
