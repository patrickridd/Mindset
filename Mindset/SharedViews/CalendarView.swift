import SwiftUI

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let isCurrentMonth: Bool
}

struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    @State private var currentWeekIndex: Int = 0

    private let calendar = Calendar.current
    private let daysOfWeek = Week.allCases
    private let daysRange: Int = 30 // Days before and after today

    private var alignedStartDate: Date {
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -daysRange, to: today) ?? today
        let weekday = calendar.component(.weekday, from: startDate)
        // weekday: 1 = Sunday, 2 = Monday, ..., 7 = Saturday
        return calendar.date(byAdding: .day, value: -(weekday - 1), to: startDate) ?? startDate
    }

    private var alignedEndDate: Date {
        let today = Date()
        let endDate = calendar.date(byAdding: .day, value: daysRange, to: today) ?? today
        let weekday = calendar.component(.weekday, from: endDate)
        // weekday: 1 = Sunday, 7 = Saturday
        return calendar.date(byAdding: .day, value: 7 - weekday, to: endDate) ?? endDate
    }

    private var allDates: [CalendarDay] {
        var dates: [CalendarDay] = []
        var date = alignedStartDate
        while date <= alignedEndDate {
            let isCurrentMonth = calendar.isDate(date, equalTo: selectedDate, toGranularity: .month)
            dates.append(CalendarDay(date: date, isCurrentMonth: isCurrentMonth))
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }
        return dates
    }

    private var weeks: [[CalendarDay]] {
        stride(from: 0, to: allDates.count, by: 7).map {
            Array(allDates[$0..<min($0 + 7, allDates.count)])
        }
    }

    private var monthString: String {
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
    
    var body: some View {
        VStack(spacing: 8) {
            monthTextView
            TabView(selection: $currentWeekIndex) {
                ForEach(weeks.indices, id: \.self) { weekIndex in
                    HStack(spacing: 8) {
                        ForEach(weeks[weekIndex]) { calendarDay in
                            calendarDayView(calendarDay: calendarDay)
                                .frame(width: 48)
                        }
                    }
                    .padding(.horizontal, 0)
                    .tag(weekIndex)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 70)
            .onAppear {
                // Set initial week index to the week containing today
                if let todayIndex = allDates.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: selectedDate) }) {
                    currentWeekIndex = todayIndex / 7
                }
            }
            .onChange(of: selectedDate) { _,_  in
                // Update week index if selectedDate changes
                if let selectedIndex = allDates.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: selectedDate) }) {
                    currentWeekIndex = selectedIndex / 7
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
    }
}

#Preview {
    CalendarView()
}

extension CalendarView {

    var monthTextView: some View {
        Text(monthString)
            .font(.headline)
            .foregroundColor(.black)
    }

    func calendarDayView(calendarDay: CalendarDay) -> some View {
        VStack(spacing: 4) {
            Text(dayOfWeek(for: calendarDay.date))
                .font(.caption)
                .foregroundColor(.gray)
            Button(action: {
                selectedDate = calendarDay.date
            }) {
                ZStack {
                    if calendar.isDate(calendarDay.date, inSameDayAs: selectedDate) {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 36, height: 36)
                    } else if !calendarDay.isCurrentMonth {
                        Circle()
                            .fill(Color.gray.opacity(0.15))
                            .frame(width: 36, height: 36)
                    }
                    Text("\(calendar.component(.day, from: calendarDay.date))")
                        .font(.body)
                        .foregroundColor(
                            calendar.isDate(calendarDay.date, inSameDayAs: selectedDate) ? .white : (calendarDay.isCurrentMonth ? .black : .gray)
                        )
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    func dayOfWeek(for date: Date) -> String {
        let weekday = calendar.component(.weekday, from: date)
        return daysOfWeek[weekday - 1].abbreviation
    }
}
