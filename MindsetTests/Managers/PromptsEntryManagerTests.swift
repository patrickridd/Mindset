//
//  PromptsEntryManagerTests.swift
//  MindsetTests
//
//  Created by patrick ridd on 7/21/25.
//

@testable import Mindset
import XCTest

final class PromptsEntryManagerTests: XCTestCase {

    var sut: PromptsEntryManager!
    var mockPromptsEntryFileStore: MockPromptsEntryFileStore!
    var morningEntry = PromptsEntry(prompts: [], dayTime: .morning)
    var nightEntry = PromptsEntry(prompts: [], dayTime: .night)

    override func setUp() {
        super.setUp()
        self.mockPromptsEntryFileStore = MockPromptsEntryFileStore()
        self.sut = PromptsEntryManager(promptsEntryPersistence: mockPromptsEntryFileStore)
    }
    
    override func tearDown() {
        super.tearDown()

        self.sut = nil
        self.mockPromptsEntryFileStore = nil
    }
    
    // MARK: getPromptsEntry method tests
 
    func test_getPromptsEntry_gets_morningPrompt() {
        // Arrange
        sut.morningEntries.insert(morningEntry)
        sut.nightEntries.insert(nightEntry)

        // Act
        let fetchedEntry = sut.getPromptsEntry(for: .today, dayTime: .morning)
        
        // Assert
        XCTAssertEqual(fetchedEntry, morningEntry)
    }

    func test_getPromptsEntry_gets_nightPrompt() {
        // Arrange
        sut.morningEntries.insert(morningEntry)
        sut.nightEntries.insert(nightEntry)

        // Act
        let fetchedEntry = sut.getPromptsEntry(for: .today, dayTime: .night)
        
        // Assert
        XCTAssertEqual(fetchedEntry, nightEntry)
    }

    func test_getPromptsEntry_returns_nil_if_entry_not_found() {
        let fetchedEntry = sut.getPromptsEntry(for: .today, dayTime: .morning)
        XCTAssertNil(fetchedEntry)
    }

    // MARK: createEntry method tests

    func test_createEntry_inserts_into_morningEntries() {
        // Arrange
        let prompts: [Prompt] = [.gratitude, .affirmation, .goalSetting]
        // Act
        let createdEntry = sut.createEntry(promptsEntryType: .morning, prompts: prompts)
        // Assert
        XCTAssertTrue(sut.morningEntries.contains(createdEntry))
    }

    func test_createEntry_inserts_into_nightEntries() {
        // Arrange
        let prompts: [Prompt] = [.reflection, .goalSetting, .gratitude]
        // Act
        let createdEntry = sut.createEntry(promptsEntryType: .night, prompts: prompts)
        // Assert
        XCTAssertTrue(sut.nightEntries.contains(createdEntry))
    }

    // MARK: saveEntry tests

    func test_saveEntry_inserts_into_morningEntries_set() {
        // Arrange
        sut.morningEntries = []
        // Act
        sut.save(entry: morningEntry)
        // Assert
        XCTAssertTrue(sut.morningEntries.contains(morningEntry))
    }

    func test_saveEntry_inserts_into_nightEntries_set() {
        // Arrange
        sut.nightEntries = []
        // Act
        sut.save(entry: nightEntry)
        // Assert
        XCTAssertTrue(sut.nightEntries.contains(nightEntry))
    }

    func test_saveEntry_saves_mutated_entry() {
        // Arrange
        XCTAssertFalse(nightEntry.completed)
        sut.nightEntries = [nightEntry]
        // Act
        nightEntry.setEntryCompleted()
        sut.save(entry: nightEntry)
        // Assert
        let modifiedNightEntry = sut.nightEntries.first(where: { $0.id == nightEntry.id })!
        XCTAssertTrue(modifiedNightEntry.completed)
    }

    func test_saveEntry_saves_to_persistence() {
        // Arrange
        mockPromptsEntryFileStore.savedEntries = []
        
        // Act
        sut.save(entry: morningEntry)
        // Assert
        XCTAssertTrue(mockPromptsEntryFileStore.savedEntries.contains(morningEntry))
    }

    // MARK: getTodaysMorningEntry tests
    
    func test_getTodaysMorningEntry_returns_morningEntry() {
        // Arrange
        sut.morningEntries = [morningEntry]
        
        // Act
        let savedEntry = sut.getTodaysMorningEntry()
        
        // Assert
        XCTAssertEqual(savedEntry, morningEntry)
    }

    func test_getTodaysMorningEntry_returns_newMorningEntry() {
        // Arrange
        sut.morningEntries = [] // no entries
        
        // Act
        let savedEntry = sut.getTodaysMorningEntry() // creates new entry
        
        // Assert
        XCTAssertNotEqual(savedEntry, morningEntry)
        XCTAssertFalse(sut.morningEntries.isEmpty)
    }
    
    func test_getTodaysNightEntry_returns_nightEntry() {
        // Arrange
        sut.nightEntries = [nightEntry]
        
        // Act
        let savedEntry = sut.getTodaysNightEntry()
        
        // Assert
        XCTAssertEqual(savedEntry, nightEntry)
    }

    func test_getTodaysNightEntry_returns_newNightEntry() {
        // Arrange
        sut.nightEntries = [] // empty
        
        // Act
        let savedEntry = sut.getTodaysNightEntry() // creates new entry
        
        // Assert
        XCTAssertNotEqual(savedEntry, nightEntry)
        XCTAssertFalse(sut.nightEntries.isEmpty)
    }

    func test_getTodaysNightEntry_returns_new_nightEntry_when_nightEntries_does_not_have_entry_for_today() {
        // Arrange
        let yesterday = Date().addingTimeInterval((-1) * 24 * 60 * 60)
        let yesterdayNightEntry = PromptsEntry(date: yesterday, prompts: [], dayTime: .night)

        sut.nightEntries = [yesterdayNightEntry] // empty
        
        // Act
        let savedEntry = sut.getTodaysNightEntry() // creates new entry night Entry
        
        // Assert
        XCTAssertNotEqual(savedEntry, yesterdayNightEntry)
        XCTAssertFalse(savedEntry.date.inSameDayAs(date: yesterday))
    }

    func test_getTodaysMorningEntry_returns_new_morningEntry_when_morningEntries_does_not_have_entry_for_today() {
        // Arrange
        let yesterday = Date().addingTimeInterval((-1) * 24 * 60 * 60)
        let yesterdayMorningEntry = PromptsEntry(date: yesterday, prompts: [], dayTime: .morning)

        sut.morningEntries = [yesterdayMorningEntry] // empty
        
        // Act
        let savedEntry = sut.getTodaysNightEntry() // creates new entry night Entry
        
        // Assert
        XCTAssertNotEqual(savedEntry, yesterdayMorningEntry)
        XCTAssertFalse(savedEntry.date.inSameDayAs(date: yesterday))
    }

    // MARK: delete(entry: PromptsEntry) tests

    func test_delete_morningEntry_removes_entry_from_morningEntries_and_persistence() {
        // Arrange
        sut.morningEntries = [morningEntry]
        mockPromptsEntryFileStore.savedEntries = [morningEntry]
        
        // Act
        sut.delete(entry: morningEntry)
        
        // Assert
        XCTAssertFalse(sut.morningEntries.contains(morningEntry))
        XCTAssertFalse(mockPromptsEntryFileStore.savedEntries.contains(morningEntry))
    }

    func test_delete_nightEntry_removes_entry_from_nightEntries_and_persistence() {
        // Arrange
        sut.nightEntries = [nightEntry]
        mockPromptsEntryFileStore.savedEntries = [nightEntry]
        
        // Act
        sut.delete(entry: nightEntry)
        
        // Assert
        XCTAssertFalse(sut.nightEntries.contains(nightEntry))
        XCTAssertFalse(mockPromptsEntryFileStore.savedEntries.contains(nightEntry))
    }
}
