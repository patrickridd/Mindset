//
//  HomeViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 6/2/25.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var presentJournalEntry: Bool = false
}
