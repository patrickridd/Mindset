//
//  MockFileStore.swift
//  MindsetTests
//
//  Created by patrick ridd on 7/16/25.
//

import Foundation

class MockFileManager: FileManager {

    var cacheURL: URL {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return URL(fileURLWithPath: "", relativeTo: cacheURL)
    }
    
    override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        [cacheURL]
    }
    
    func clearAppCache() {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil, options: [])
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
            print("Cache cleared successfully!")
        } catch {
            print("Error clearing cache: \(error.localizedDescription)")
        }
    }

}
