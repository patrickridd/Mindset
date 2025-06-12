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
        VStack(spacing: 8) {
            navTitle
            CalendarView()
            VStack(spacing: 12) {
                Spacer()
                journalButton
                    .padding(.bottom, 100)
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(coordinator: Coordinator()))
}

extension HomeView {

    var navTitle: some View {
        Text("Daily Mindset")
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top], 16)
    }

    var buttonTitle: some View {
        Text("Tap to begin")
            .font(.subheadline)
            .foregroundStyle(.orange)
    }

    var journalButton: some View {
        Button(action: {
            viewModel.journalButtonTapped()
        }) {
            VStack {
                Image(systemName: "square.and.pencil.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.indigo)
                buttonTitle
            }
            .sensoryFeedback(.selection, trigger: viewModel.presentJournalEntry)
        }
    }
}
