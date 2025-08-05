//
//  ProfileViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 8/4/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var notificationsEnabled: Bool = false

//    init(name: String = "", notificationsEnabled: Bool = false) {
//        self.name = name
//        self.notificationsEnabled = notificationsEnabled
//    }
}
