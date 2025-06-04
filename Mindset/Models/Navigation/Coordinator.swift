//
//  AppCoordinator.swift
//  Mindset
//
//  Created by patrick ridd on 6/4/25.
//

import SwiftUI

class Coordinator: Coordinatable {
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: (any CoordinatedView)?
    @Published var fullScreenCover: (any CoordinatedView)?
    
    func push(_ screen: any CoordinatedView) {
        path.append(screen)
    }
    
    func presentSheet(_ sheet: any CoordinatedView) {
        self.sheet = sheet
    }
    
    func presentFullScreenCover(_ fullScreenCover: any CoordinatedView) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    func dismissFullScreenOver() {
        fullScreenCover = nil
    }
}
