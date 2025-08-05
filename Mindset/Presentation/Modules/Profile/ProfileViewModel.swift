//
//  ProfileViewModel.swift
//  Mindset
//
//  Created by patrick ridd on 8/4/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
   
    @Published var name: String = "" {
        didSet {
            profilePersistence.saveUser(name: name)
        }
    }

    @Published var notificationsEnabled: Bool = false {
        didSet {
            profilePersistence.saveUserNotificationsEnabled(notificationsEnabled)
        }
    }
    
    let profilePersistence: ProfilePersistence
    
    init (userPersistence: ProfilePersistence = ProfilePersistence()) {
        self.profilePersistence = userPersistence
        self.name = userPersistence.getUserName() ?? ""
        self.notificationsEnabled = userPersistence.getUserNotificationsEnabled()
    }
}
