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
    var mockPromptsEntryManager: MockPromptsEntryManager!
    var morningMockEntry = PromptsEntry.init(prompts: DayTime.morning.defaultPrompts, dayTime: .morning)
    var nightMockEntry = PromptsEntry.init(prompts: DayTime.night.defaultPrompts, dayTime: .night)

    override func setUp() {
        self.mockPromptsEntryManager = MockPromptsEntryManager()
        self.sut = TodayViewModel(
            coordinator: MockCoordinator(viewFactory: ViewFactory(), path: NavigationPath()),
            promptsEntryManager: mockPromptsEntryManager
        )
    }

    // MARK: todoCardItem tests

    func test_todoCardItems_count() {
        XCTAssertEqual(sut.todoCardItems.count, 3)
    }

    func test_todoCardItems_order() {
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
    
    // MARK: currentStep tests

    func test_currentStep_is_ZERO_when_mood_IsNil() {
        XCTAssert(sut.moodValue == nil)
        XCTAssertEqual(sut.currentStep, 0)
        // act
        sut.moodValue = 1
        // assert
        XCTAssertNotEqual(sut.currentStep, 0)
    }

    func test_currentStep_is_ONE_when_mood_NOT_NIL_and_morningPrompt_NOT_Complete() {
        // arrange
        self.mockPromptsEntryManager.save(entry: morningMockEntry)
        self.sut = TodayViewModel(
            coordinator: MockCoordinator(viewFactory: ViewFactory(), path: NavigationPath()),
            promptsEntryManager: mockPromptsEntryManager
        )
        // act
        sut.moodValue = 1
        
        // assert
        XCTAssertNotNil(sut.moodValue)
        XCTAssertFalse(sut.morningPromptsEntry.completed)
        XCTAssertEqual(sut.currentStep, 1)
    }

    func test_currentStep_is_TWO_when_mood_NOT_NIL_and_morningPrompt_IS_Complete() {
        // arrange
        morningMockEntry.setEntryCompleted()
        self.mockPromptsEntryManager.save(entry: morningMockEntry)
        self.sut = TodayViewModel(
            coordinator: MockCoordinator(viewFactory: ViewFactory(), path: NavigationPath()),
            promptsEntryManager: mockPromptsEntryManager
        )
        // act
        sut.moodValue = 1
        
        // assert
        XCTAssertNotNil(sut.moodValue)
        XCTAssertTrue(sut.morningPromptsEntry.completed)
        XCTAssertEqual(sut.currentStep, 2)
    }

    func test_morningPromptsEntry_not_nil() {
        XCTAssertNotNil(sut.morningPromptsEntry)
    }

    func test_nightPromptsEntry_not_nil() {
        XCTAssertNotNil(sut.nightPromptsEntry)
    }
}
