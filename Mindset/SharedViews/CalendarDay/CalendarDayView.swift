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
            Text(viewModel.dayOfWeek())
                .font(.caption)
                .foregroundColor(.gray)
            Button(action: {
                viewModel.dayTapped()
            }) {
                ZStack {
                    if viewModel.isSelectedDay {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 36, height: 36)
                    } else if !viewModel.isCalendarDayInCurrentMonth {
                        Circle()
                            .fill(Color.gray.opacity(0.15))
                            .frame(width: 36, height: 36)
                    }
                    Text(viewModel.calendarDayString)
                        .font(.body)
                        .foregroundColor(
                            viewModel.isSelectedDay ? .white : (viewModel.isCalendarDayInCurrentMonth ? .black : .gray)
                        )
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    HStack {
        CalendarDayView(viewModel: CalendarDayViewModel(calendarDay: CalendarDay.init(date: Date(), isCurrentMonth: true), parentViewModel: CalendarViewModel()))
        CalendarDayView(viewModel: CalendarDayViewModel(calendarDay: .init(date: Date().addingTimeInterval(60*60*24), isCurrentMonth: false), parentViewModel: CalendarViewModel()))
    }
}
