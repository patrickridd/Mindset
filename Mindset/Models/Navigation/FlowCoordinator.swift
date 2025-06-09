//
//  CoordinatedFlow.swift
//  Mindset
//
//  Created by patrick ridd on 6/5/25.
//

import SwiftUI

@MainActor
protocol FlowCoordinator: ObservableObject {
    associatedtype CoordinatedFlowStep
    var path: NavigationPath { get set }
    var steps: [CoordinatedFlowStep] { get }
    
    init(steps: [CoordinatedFlowStep])

    func start()
    func next()
    func back()
    func view(for step: CoordinatedFlowStep) -> AnyView
    func currentView() -> AnyView?
}
