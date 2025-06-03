//
//  CalendarDayView.swift
//  Mindset
//
//  Created by patrick ridd on 5/20/25.
//

import SwiftUI

struct CalendarDayView: View {

    @ObservedObject var viewModel: CalendarDayViewModel
    
    var body: some View {
        VStack(spacing: 4) {
            Text(viewModel.dayOfWeek)
                .font(.caption)
                .foregroundColor(viewModel.dayOfWeekTextColor)
                .fontWeight(viewModel.dayOfWeekFontWeight)
            Button(action: {
                viewModel.dayTapped()
            }) {
                ZStack {
                    Circle()
                        .fill(viewModel.circleColor)
                        .strokeBorder(viewModel.circleBorderColor, lineWidth: viewModel.circleLineWidth)
                        .frame(width: 36, height: 36)
                        
                    Text(viewModel.calendarDayDigit)
                        .font(.body)
                        .foregroundColor(
                            viewModel.digitTextColor
                        )
                        .fontWeight(viewModel.numberTextFontWeight)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    HStack {
        CalendarDayView(viewModel: CalendarDayViewModel(calendarDay: CalendarDay.init(date: Date().addingTimeInterval(60*60*24*(-1)), isCurrentMonth: true), parentViewModel: CalendarViewModel()))
        CalendarDayView(viewModel: CalendarDayViewModel(calendarDay: CalendarDay.init(date: Date(), isCurrentMonth: true), parentViewModel: CalendarViewModel()))
        CalendarDayView(viewModel: CalendarDayViewModel(calendarDay: .init(date: Date().addingTimeInterval(60*60*24), isCurrentMonth: true), parentViewModel: CalendarViewModel()))
        CalendarDayView(viewModel: CalendarDayViewModel(calendarDay: .init(date: Date().addingTimeInterval(60*60*24*2), isCurrentMonth: true), parentViewModel: CalendarViewModel()))
    }
}
