//
//  AppCoordinator.swift
//  Mindset
//
//  Created by patrick ridd on 6/4/25.
//

import SwiftUI

@MainActor
protocol Coordinated: ObservableObject {
    var viewFactory: ViewFactory { get }
    var path: NavigationPath { get set }
    var sheet: CoordinatedView? { get set }
    var fullScreenCover: CoordinatedView? { get set }

    func push(_ screen: CoordinatedView)
    func presentSheet(_ sheet: CoordinatedView)
    func presentFullScreenCover(_ fullScreenCover: CoordinatedView)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenCover()
    associatedtype BuiltView: View
    func build(_ screen: CoordinatedView) -> BuiltView
}

