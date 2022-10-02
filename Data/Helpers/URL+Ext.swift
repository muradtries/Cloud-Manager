//
//  URL+Ext.swift
//  Data
//
//  Created by Murad on 20.09.22.
//

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
}
