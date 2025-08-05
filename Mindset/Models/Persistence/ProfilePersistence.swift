//
//  UserPersistence.swift
//  Mindset
//
//  Created by patrick ridd on 8/4/25.
//

import Foundation

private let userDefaultsNameKey = "profile_name"
private let userDefaultsNotificationsKey = "profile_notifications_enabled"

struct ProfilePersistence {
    
    let userDefaults: UserDefaults
    
    init (userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveUser(name: String) {
        userDefaults.set(name, forKey: userDefaultsNameKey)
    }

    func getUserName() -> String? {
        userDefaults.string(forKey: userDefaultsNameKey)
    }

    func saveUserNotificationsEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: userDefaultsNotificationsKey)
    }

    func getUserNotificationsEnabled() -> Bool {
        userDefaults.bool(forKey: userDefaultsNotificationsKey)
    }

}
