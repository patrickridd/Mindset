import SwiftUI

struct CalendarWeekView: View {
    
    @ObservedObject private var viewModel: CalendarWeekViewModel

    init(viewModel: CalendarWeekViewModel = CalendarWeekViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                monthTextView
            }
            TabView(selection: $viewModel.currentWeekIndex) {
                ForEach(viewModel.weeks.indices, id: \.self) { weekIndex in
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
                    viewModel.currentWeekIndex = min(max(viewModel.currentWeekIndex, 0), viewModel.weeks.count - 1)
                }
            }
            .onChange(of: viewModel.selectedDate) { _,_  in
                // Update week index if selectedDate changes
                if let selectedIndex = viewModel.allDates.firstIndex(where: {
                    viewModel.calendar.isDate($0.date, inSameDayAs: viewModel.selectedDate)
                }) {
                    viewModel.currentWeekIndex = selectedIndex / 7
                    viewModel.currentWeekIndex = min(max(viewModel.currentWeekIndex, 0), viewModel.weeks.count - 1)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    CalendarWeekView()
}

extension CalendarWeekView {

    var monthTextView: some View {
        Text(viewModel.monthString)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.orange)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

}
