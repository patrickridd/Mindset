//
//  PromptsEntryFileStoreTests.swift
//  MindsetTests
//
//  Created by patrick ridd on 7/16/25.
//
import Foundation
@testable import Mindset
import Testing

struct PromptsEntryFileStoreTests {

    let mockFileManager: MockFileManager
    let sut: PromptsEntryFileStore

    init() {
        self.mockFileManager = MockFileManager()
        self.sut = PromptsEntryFileStore(fileManager: mockFileManager)
    }
    
    @Test func fileURL_returns_URL() {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let url = sut.fileURL(path: DayTime.morning.urlPath)
        #expect(url.pathExtension == "json")
        #expect(url.path.contains("MorningMindset.json"))
    }

    @Test func load_morning_promptsEntries() throws {
        try sut.saveEntries(
            [.init(entryDate: .today, prompts: DayTime.morning.defaultPrompts, dayTime: .morning)],
            for: .morning
        )
        #expect(sut.loadPrompts(for: .morning).count == 1)
        #expect(sut.loadPrompts(for: .night).count == 0)
    }

    @Test func load_night_promptsEntries() throws {
        try sut.saveEntries(
            [.init(entryDate: .today, prompts: DayTime.night.defaultPrompts, dayTime: .night)],
            for: .night
        )
        #expect(sut.loadPrompts(for: .morning).count == 0)
        #expect(sut.loadPrompts(for: .night).count == 1)
    }
}
