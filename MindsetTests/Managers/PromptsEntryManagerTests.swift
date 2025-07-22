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
        sut.morningEntries[Date().startOfDay] = morningEntry
        sut.nightEntries[Date().startOfDay] = nightEntry

        // Act
        let fetchedEntry = sut.getPromptsEntry(for: .today, dayTime: .morning)
        
        // Assert
        XCTAssertEqual(fetchedEntry, morningEntry)
    }

    func test_getPromptsEntry_gets_nightPrompt() {
        // Arrange
        sut.morningEntries[Date().startOfDay] = morningEntry
        sut.nightEntries[Date().startOfDay] = nightEntry

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
        XCTAssertEqual(sut.morningEntries.first!.value, createdEntry)
    }

    func test_createEntry_inserts_into_nightEntries() {
        // Arrange
        let prompts: [Prompt] = [.reflection, .goalSetting, .gratitude]
        // Act
        let createdEntry = sut.createEntry(promptsEntryType: .night, prompts: prompts)
        // Assert
        XCTAssertEqual(sut.nightEntries.first!.value, createdEntry)
    }

    func test_createEntry_saves_entry_into_persistence() {
        // Arrange
        mockPromptsEntryFileStore.savedEntries = []

        // Act
        let createdEntry = sut.createEntry(promptsEntryType: .morning, prompts: [.gratitude, .affirmation, .goalSetting])
        // Assert
        XCTAssertEqual(mockPromptsEntryFileStore.savedEntries.first!, createdEntry)
    }

    // MARK: morningEntries data source tests

    func test_morningEntry_keys_are_startOfDate() {
        // Arrange
        let prompts: [Prompt] = [.gratitude, .affirmation, .goalSetting]
        let createdEntry = sut.createEntry(promptsEntryType: .morning, prompts: prompts)
       
        // Act
        let startOfDateKey = createdEntry.date.startOfDay
        let startOfDateEntryValue = sut.morningEntries[startOfDateKey]
        
        // Assert
        XCTAssertEqual(startOfDateEntryValue, createdEntry)
    }

    // MARK: nightEntries data source tests

    func test_nightEntry_keys_are_startOfDate() {
        // Arrange
        let prompts: [Prompt] = [.gratitude, .affirmation, .goalSetting]
        let createdEntry = sut.createEntry(promptsEntryType: .night, prompts: prompts)
       
        // Act
        let startOfDateKey = createdEntry.date.startOfDay
        let startOfDateEntryValue = sut.nightEntries[startOfDateKey]
        
        // Assert
        XCTAssertEqual(startOfDateEntryValue, createdEntry)
    }

}
