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
            topBar
            CalendarWeekView()
                .padding(.horizontal)
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

    var topBar: some View {
        HStack(alignment: .center) {
            navTitle
            Spacer()
            HStack(spacing: 16) {
                StreakTracker()
                profileButton
            }
        }
        .padding(.horizontal, 16)
    }

    var navTitle: some View {
        Text("Mindset")
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity,
                   alignment: .leading)
    }

    var profileButton: some View {
        Button {
            
        } label: {
           Image(systemName: "person.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.indigo)
        }
    }
    
    var buttonTitle: some View {
        Text("Tap to begin")
            .font(.headline)
            .foregroundStyle(.orange)
    }

    var journalButton: some View {
        Button(action: {
            viewModel.journalButtonTapped()
        }) {
            VStack(spacing: 12) {
                Image(systemName: "square.and.pencil.circle.fill")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(.indigo)
                buttonTitle
            }
            .sensoryFeedback(.selection, trigger: viewModel.presentJournalEntry)
        }
    }

}
