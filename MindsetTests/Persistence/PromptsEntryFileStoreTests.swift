//
//  PromptsEntryFileStoreTests.swift
//  MindsetTests
//
//  Created by patrick ridd on 7/16/25.
//
import Foundation
@testable import Mindset
import Testing

//class PromptsEntryFileStoreTests {
//
//    let mockFileManager: MockFileManager
//    let sut: PromptsEntryFileStore
//
//    init() {
//        self.mockFileManager = MockFileManager()
//        self.sut = PromptsEntryFileStore(fileManager: mockFileManager)
//    }
//    
//    deinit {
//        mockFileManager.clearAppCache()
//    }
//
//    @Test func fileURL_returns_URL() {
//        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//        let url = sut.fileURL(path: DayTime.morning.urlPath)
//        #expect(url.pathExtension == "json")
//        #expect(url.path.contains("MorningMindset.json"))
//    }
//
//    @Test func load_morning_and_night_promptsEntries() throws {
//        let morningEntry = PromptsEntry(prompts: DayTime.morning.defaultPrompts, dayTime: .morning)
//        let nightEntry = PromptsEntry(prompts: DayTime.night.defaultPrompts, dayTime: .night)
//        try sut.saveEntries(
//            [morningEntry],
//            for: .morning
//        )
//        #expect(sut.loadPrompts(for: .morning).count == 1)
//        #expect(sut.loadPrompts(for: .night).count == 0)
//        
//        try sut.saveEntries(
//            [nightEntry],
//            for: .night
//        )
//        #expect(sut.loadPrompts(for: .morning).count == 1)
//        #expect(sut.loadPrompts(for: .night).count == 1)
//    }
//
//    @Test func delete_entry() throws {
//        let morningEntry = PromptsEntry(entryDate: .today, prompts: DayTime.morning.defaultPrompts, dayTime: .morning)
//        try sut.saveEntries(
//            [morningEntry],
//            for: .morning
//        )
//        #expect(sut.loadPrompts(for: .morning).count == 1)
//        sut.delete(morningEntry)
//        #expect(sut.loadPrompts(for: .morning).count == 0)
//    }
//}
