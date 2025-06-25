//
//  CoordinatedFlowStep.swift
//  Mindset
//
//  Created by patrick ridd on 6/5/25.
//

import SwiftUI

protocol CoordinatedFlowStep: Identifiable, Hashable {
    var id: String { get }
}

extension CoordinatedFlowStep {

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
