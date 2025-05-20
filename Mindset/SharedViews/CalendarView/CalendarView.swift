import SwiftUI

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let isCurrentMonth: Bool
}

struct CalendarView: View {
    
    @ObservedObject private var viewModel = CalendarViewModel()

    var body: some View {
        VStack(spacing: 8) {
            monthTextView
            TabView(selection: $viewModel.currentWeekIndex) {
                ForEach(Week.allCases.indices, id: \.self) { weekIndex in
                    HStack(spacing: 8) {
                        ForEach(viewModel.weeks[weekIndex]) { calendarDay in
                            CalendarDayView(viewModel: CalendarDayViewModel(calendarDay: calendarDay, parentViewModel: viewModel))
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
                if let todayIndex = viewModel.allDates.firstIndex(where: {
                    viewModel.calendar.isDate($0.date, inSameDayAs: viewModel.selectedDate)
                }) {
                    viewModel.currentWeekIndex = todayIndex / 7
                }
            }
            .onChange(of: viewModel.selectedDate) { _,_  in
                // Update week index if selectedDate changes
                if let selectedIndex = viewModel.allDates.firstIndex(where: {
                    viewModel.calendar.isDate($0.date, inSameDayAs: viewModel.selectedDate)
                }) {
                    viewModel.currentWeekIndex = selectedIndex / 7
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
    }
}

#Preview {
//    CalendarView(viewModel: CalendarViewModel())
}

extension CalendarView {

    var monthTextView: some View {
        Text(viewModel.monthString)
            .font(.headline)
            .foregroundColor(.black)
    }

}
