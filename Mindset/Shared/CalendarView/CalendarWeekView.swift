import SwiftUI

struct CalendarWeekView: View {
    
    @ObservedObject private var viewModel: CalendarWeekViewModel

    init(selectedDate: Binding<Date>) {
        self.viewModel = CalendarWeekViewModel(selectedDate: selectedDate)
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
            .onChange(of: viewModel.selectedDate) { _,_  in
                viewModel.selectedDayDidChange()
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    CalendarWeekView(selectedDate: .constant(Date()))
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
