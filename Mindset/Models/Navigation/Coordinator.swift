//
//  AppCoordinator.swift
//  Mindset
//
//  Created by patrick ridd on 6/4/25.
//

import SwiftUI

@MainActor
class Coordinator: Coordinated {
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: CoordinatedView?
    @Published var fullScreenCover: CoordinatedView?

    let viewFactory: ViewFactory

    init(viewFactory: ViewFactory) {
        self.viewFactory = viewFactory
    }
    
    func push(_ screen: CoordinatedView) {
        path.append(screen)
    }
    
    func presentSheet(_ sheet: CoordinatedView) {
        self.sheet = sheet
    }
    
    func presentFullScreenCover(_ fullScreenCover: CoordinatedView) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }

    func dismissFullScreenCover() {
        fullScreenCover = nil
    }
    
    func dismissSheet() {
        sheet = nil
    }

    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: CoordinatedView) -> some View {
        viewFactory.makeView(for: screen, coordinator: self)
    }
}
