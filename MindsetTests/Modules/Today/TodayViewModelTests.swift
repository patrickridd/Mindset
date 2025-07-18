//
//  TodayViewModelTests.swift
//  MindsetTests
//
//  Created by patrick ridd on 7/17/25.
//

@testable import Mindset
import SwiftUI
import XCTest

@MainActor
final class TodayViewModelTests: XCTestCase {
    
    var sut: TodayViewModel!
    
    override func setUp() {
        sut = TodayViewModel(
            coordinator: MockCoordinator(viewFactory: ViewFactory(), path: NavigationPath()),
            promptsEntryManager: MockPromptsEntryManager()
        )
    }

    func test_todoCardItems_count() {
        XCTAssertEqual(sut.todoCardItems.count, 3)
    }

    func test_todoCardItems_order {
//        for (index, todo) in sut.todoCardItems.enumerated() {
//            switch index {
//            case 0:
//                XCTAssertEqual(todo.progressStatus == , sut.morningMindsetCard)
//            case 1:
//                
//            case 2:
//            default:
//                XCTFail("Failure: More than 3 items")
//            }
//        }
    }

    func 

}
