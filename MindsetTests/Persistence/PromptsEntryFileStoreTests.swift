//
//  PromptsEntryFileStoreTests.swift
//  MindsetTests
//
//  Created by patrick ridd on 7/16/25.
//

@testable import Mindset
import XCTest

final class PromptsEntryFileStoreTests: XCTestCase {

    var mockFileManager: MockFileManager!
    var sut: PromptsEntryFileStore!
    
    override func setUp() {
        self.mockFileManager = MockFileManager()
        self.sut = PromptsEntryFileStore(fileManager: mockFileManager)
    }

    override func tearDown() {
        mockFileManager.clearAppCache()
    }

    func test_fileURL_returns_URL() {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let url = sut.fileURL(path: DayTime.morning.urlPath)
        XCTAssertEqual(url.pathExtension, "json")
        XCTAssertTrue(url.path.contains("MorningMindset.json"))
    }

    func test_load_morning_promptsEntries() throws {
        let morningEntry = PromptsEntry(prompts: DayTime.morning.defaultPrompts, dayTime: .morning)
        let nightEntry = PromptsEntry(prompts: DayTime.night.defaultPrompts, dayTime: .night)
        try sut.saveEntries(
            [morningEntry],
            for: .morning
        )
        XCTAssertTrue(sut.loadPrompts(for: .morning).count == 1)
        XCTAssertTrue(sut.loadPrompts(for: .night).count == 0)
        
        try sut.saveEntries(
            [nightEntry],
            for: .night
        )
        XCTAssertEqual(sut.loadPrompts(for: .morning).count, 1)
        XCTAssertEqual(sut.loadPrompts(for: .night).count, 1)
    }
    
    func test_load_night_promptsEntries() throws {
        let nightEntry = PromptsEntry(prompts: DayTime.night.defaultPrompts, dayTime: .night)
        try sut.saveEntries(
            [nightEntry],
            for: .night
        )
        XCTAssertEqual(sut.loadPrompts(for: .night).count, 1)
        XCTAssertEqual(sut.loadPrompts(for: .morning).count, 0)
    }

    func test_load_morning_and_night_promptsEntries() throws {
        let morningEntry = PromptsEntry(prompts: DayTime.morning.defaultPrompts, dayTime: .morning)
        let nightEntry = PromptsEntry(prompts: DayTime.night.defaultPrompts, dayTime: .night)
        try sut.saveEntries(
            [morningEntry],
            for: .morning
        )
        XCTAssertTrue(sut.loadPrompts(for: .morning).count == 1)
        XCTAssertTrue(sut.loadPrompts(for: .night).count == 0)
        
        try sut.saveEntries(
            [nightEntry],
            for: .night
        )
        XCTAssertEqual(sut.loadPrompts(for: .morning).count, 1)
        XCTAssertEqual(sut.loadPrompts(for: .night).count, 1)
    }

    func test_saveEntries_only_saves_morning_matches() throws {
        let morningEntry = PromptsEntry(entryDate: .today, prompts: DayTime.morning.defaultPrompts, dayTime: .morning)
        let nightEntry = PromptsEntry(prompts: DayTime.night.defaultPrompts, dayTime: .night)
        try sut.saveEntries([morningEntry, nightEntry], for: .morning)
        XCTAssertTrue(sut.loadPrompts(for: .morning).count == 1)
        XCTAssertTrue(sut.loadPrompts(for: .night).count == 0)
    }
    
    func test_saveEntries_only_saves_night_matches() throws {
        let morningEntry = PromptsEntry(entryDate: .today, prompts: DayTime.morning.defaultPrompts, dayTime: .morning)
        let nightEntry = PromptsEntry(prompts: DayTime.night.defaultPrompts, dayTime: .night)
        try sut.saveEntries([morningEntry, nightEntry], for: .night)
        XCTAssertTrue(sut.loadPrompts(for: .morning).count == 0)
        XCTAssertTrue(sut.loadPrompts(for: .night).count == 1)
    }
    
    func test_delete_entry() throws {
        let morningEntry = PromptsEntry(entryDate: .today, prompts: DayTime.morning.defaultPrompts, dayTime: .morning)
        try sut.saveEntries(
            [morningEntry],
            for: .morning
        )
        XCTAssertTrue(sut.loadPrompts(for: .morning).count == 1)
        sut.delete(morningEntry)
        XCTAssertTrue(sut.loadPrompts(for: .morning).count == 0)
    }

    func test_saveEntry_success() {
        let morningEntry = PromptsEntry(entryDate: .today, prompts: DayTime.morning.defaultPrompts, dayTime: .morning)
        sut.saveEntry(morningEntry)
        XCTAssertTrue(sut.loadPrompts(for: .morning).count == 1)
    }

}
