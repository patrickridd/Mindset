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
    var stepsCompleted: Int { get }
    var onCompletion: () -> Void { get }

    init(steps: [CoordinatedFlowStep], onCompletion: @escaping () -> Void)

    func start()
    func completeStep()
    func next()
    func back()
    func view(for step: CoordinatedFlowStep) -> AnyView
}
