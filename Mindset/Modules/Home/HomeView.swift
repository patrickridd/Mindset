//
//  ContentView.swift
//  Mindset
//
//  Created by patrick ridd on 5/14/25.
//

import SwiftUI

struct HomeView: CoordinatedView {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            CalendarView()
            Spacer()
            journalButton
                .padding(.bottom, 100)
            Spacer()
        }
        .fullScreenCover(isPresented: $viewModel.presentJournalEntry, content: {
            JournalEntryFlowView()
        })
    }
}

#Preview {
    HomeView()
}

extension HomeView {

    var journalButton: some View {
        Button(action: {
            viewModel.presentJournalEntry.toggle()
        }) {
            Image(systemName: "square.and.pencil.circle")
                .resizable()
                .frame(width: 250, height: 250)
        }
    }
}
