//
//  AppCoordinator.swift
//  Mindset
//
//  Created by patrick ridd on 6/4/25.
//

import SwiftUI

protocol Coordinatable: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: (any CoordinatedView)? { get set }
    var fullScreenCover: (any CoordinatedView)? { get set }

    func push(_ screen: any CoordinatedView)
    func presentSheet(_ sheet: any CoordinatedView)
    func presentFullScreenCover(_ fullScreenCover: any CoordinatedView)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenOver()
}

