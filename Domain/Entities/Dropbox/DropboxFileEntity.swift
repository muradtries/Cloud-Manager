//
//  DropboxFileEntity.swift
//  Domain
//
//  Created by Murad on 22.09.22.
//

import Foundation

public struct DropboxFileEntity {
    public let identifier: String
    public let parentFolderPath: String
    public let name: String
    public let lastModified: Date
    public let path: String
    public let mimeType: EDropboxFileMimeType
    
    public init(identifier: String,
                parentFolderPath: String,
                name: String,
                lastModified: Date,
                path: String,
                mimeType: EDropboxFileMimeType) {
        self.identifier = identifier
        self.parentFolderPath = parentFolderPath
        self.name = name
        self.lastModified = lastModified
        self.path = path
        self.mimeType = mimeType
    }
}
