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
    
    // MARK: promptEntry method tests
 
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

}
