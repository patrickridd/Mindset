//
//  MockCoordinator.swift
//  MindsetTests
//
//  Created by patrick ridd on 7/17/25.
//

import Combine
import Foundation
@testable import Mindset
import SwiftUI

@MainActor
class MockCoordinator: Coordinated, ObservableObject {

    @Published var path: NavigationPath
    @Published var sheet: CoordinatedView?
    @Published var fullScreenCover: CoordinatedView?
    var viewFactory: ViewFactory

    init(viewFactory: ViewFactory, path: NavigationPath, sheet: CoordinatedView? = nil, fullScreenCover: CoordinatedView? = nil) {
        self.viewFactory = viewFactory
        self.path = path
        self.sheet = sheet
        self.fullScreenCover = fullScreenCover
    }
    
    func push(_ screen: CoordinatedView) {
    }
    
    func presentSheet(_ sheet: CoordinatedView) {
    }
    
    func presentFullScreenCover(_ fullScreenCover: CoordinatedView) {
    }
    
    func pop() {
    }
    
    func popToRoot() {
    }
    
    func dismissSheet() {
    }
    
    func dismissFullScreenCover() {
    }
    
    func build(_ screen: CoordinatedView) -> some View {
        EmptyView()
    }

}
