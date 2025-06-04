//
//  ViewHashable.swift
//  Mindset
//
//  Created by patrick ridd on 6/4/25.
//

import SwiftUI

protocol CoordinatedView: View, Hashable, Identifiable {}

extension CoordinatedView {
    public var id: Self { self }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
