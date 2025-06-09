//
//  ContentView.swift
//  Mindset
//
//  Created by patrick ridd on 5/14/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            CalendarView()
            Spacer()
            journalButton
                .padding(.bottom, 100)
            Spacer()
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(coordinator: Coordinator()))
}

extension HomeView {

    var journalButton: some View {
        Button(action: {
            viewModel.journalButtonTapped()
        }) {
            Image(systemName: "square.and.pencil.circle")
                .resizable()
                .frame(width: 250, height: 250)
        }
    }
}
