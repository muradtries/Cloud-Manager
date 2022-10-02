//
//  URL+Ext.swift
//  Presentation
//
//  Created by Murad on 10.09.22.
//

import Foundation

extension URL {
    func getFiles() throws -> [URL] {
        guard hasDirectoryPath else { return [] }
        return try! FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil)
            .filter(\.isFileURL)
    }
    
    func subDirectories() throws -> [URL] {
        guard hasDirectoryPath else { return [] }
        return try! FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil)
            .filter(\.hasDirectoryPath)
    }
    
    var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName }
}
