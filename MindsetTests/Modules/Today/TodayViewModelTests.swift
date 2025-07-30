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
        // Arrange
        self.mockPromptsEntryManager = MockPromptsEntryManager()
        self.sut = TodayViewModel(
            coordinator: MockCoordinator(viewFactory: ViewFactory(), path: NavigationPath()),
            promptsEntryManager: mockPromptsEntryManager
        )
    }

    // MARK: loadTodayEntries && todaysEntries tests

    func test_todaysEntries_count_zero_before_calling_loadTodayEntries() {
        // Assert
        XCTAssertEqual(sut.todaysEntries.count, 0)
    }

    func test_todaysEntries_count_two_after_calling_loadTodayEntries() {
        // Act
        sut.loadTodayEntries()
        
        // Assert
        XCTAssertEqual(sut.todaysEntries.count, 2)
    }

    func test_todaysEntries_morningEntry_is_first() {
        // Act
        sut.loadTodayEntries()
        let firstEntry = sut.todaysEntries.first!

        // Assert
        XCTAssertEqual(firstEntry.dayTime, .morning)
    }

    func test_todaysEntries_nightEntry_is_second() {
        // Act
        sut.loadTodayEntries()
        let secondEntry = sut.todaysEntries[1]

        // Assert
        XCTAssertEqual(secondEntry.dayTime, .night)
    }

    // MARK: 'progressStatus(for entry: PromptsEntry) -> ProgressStatus' tests

   func test_progressStatus_for_morning_entry_is_inProgress() {
       // Arrange
       sut.loadTodayEntries()
       let morningEntry = sut.todaysEntries.first!
       let progressStatus = sut.progressStatus(for: morningEntry)
       // Assert
       XCTAssertEqual(progressStatus, .inProgress)
    }

    func test_progressStatus_for_morning_entry_is_completed() {
        // Arrange
        sut.loadTodayEntries()
        let morningEntry = sut.todaysEntries.first!
        
        // Act
        morningEntry.setEntryCompleted()
        
        // Assert
        XCTAssertEqual(sut.progressStatus(for: morningEntry), .completed)
     }
    
    func test_progressStatus_for_night_entry_is_locked_when_morningEntry_NOT_completed() {
        // Arrange
        sut.loadTodayEntries()
        let morningEntry = sut.todaysEntries.first!
        let nightEntry = sut.todaysEntries[1]

        // Assert
        XCTAssertFalse(morningEntry.completed)
        XCTAssertEqual(sut.progressStatus(for: nightEntry), .locked)
     }

    func test_progressStatus_for_night_entry_is_inProgress_when_morningEntry_completed() {
        // Arrange
        sut.loadTodayEntries()
        let morningEntry = sut.todaysEntries.first!
        let nightEntry = sut.todaysEntries[1]

        // Act
        morningEntry.setEntryCompleted()
        
        // Assert
        XCTAssertTrue(morningEntry.completed)
        XCTAssertEqual(sut.progressStatus(for: nightEntry), .inProgress)
     }

    func test_progressStatus_for_night_entry_is_completed() {
        // Arrange
        sut.loadTodayEntries()
        let nightEntry = sut.todaysEntries[1]
        
        // Act
        nightEntry.setEntryCompleted()
        
        // Assert
        XCTAssertEqual(sut.progressStatus(for: nightEntry), .completed)
     }
    
    // MARK: 'title' tests
    
    func test_title_for_morning() {
        // Arrange
        self.sut = TodayViewModel(
            coordinator: MockCoordinator(viewFactory: ViewFactory(), path: NavigationPath()),
            promptsEntryManager: mockPromptsEntryManager,
            dayTime: .morning // Morning
        )

        // Assert
        XCTAssertEqual(sut.title, "Good Morning!")
    }

    func test_title_for_night() {
        // Arrange
        self.sut = TodayViewModel(
            coordinator: MockCoordinator(viewFactory: ViewFactory(), path: NavigationPath()),
            promptsEntryManager: mockPromptsEntryManager,
            dayTime: .night // Night
        )

        // Assert
        XCTAssertEqual(sut.title, "Evening wind down...")
    }
    
    // MARK: 'subtitle' tests
    func test_subtitle_for_morning() {
        // Arrange
        self.sut = TodayViewModel(
            coordinator: MockCoordinator(viewFactory: ViewFactory(), path: NavigationPath()),
            promptsEntryManager: mockPromptsEntryManager,
            dayTime: .morning // Morning
        )

        // Assert
        XCTAssertEqual(sut.subtitle, "Start your day off right!")
    }

    func test_subtitle_for_night() {
        // Arrange
        self.sut = TodayViewModel(
            coordinator: MockCoordinator(viewFactory: ViewFactory(), path: NavigationPath()),
            promptsEntryManager: mockPromptsEntryManager,
            dayTime: .night // Night
        )

        // Assert
        XCTAssertEqual(sut.subtitle, "Lets put this day to bed.")
    }
}
