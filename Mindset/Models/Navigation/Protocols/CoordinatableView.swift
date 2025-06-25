//
//  CoordinatableView.swift
//  Mindset
//
//  Created by patrick ridd on 6/24/25.
//

import SwiftUI

protocol CoordinatableView: View, Hashable, Identifiable {}

extension CoordinatableView {

    public var id: Self { self }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
