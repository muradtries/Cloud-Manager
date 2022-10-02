//
//  GoogleDriveFileEntity.swift
//  Domain
//
//  Created by Murad on 28.08.22.
//

import Foundation

public struct GoogleDriveFileEntity {
    public let identifier: String
    public let name: String
    public let mimeType: EGoogleDriveFileMimeType
    public let trashed: Bool
    public let starred: Bool
    public let shared: Bool
    public let webContentLink: String
    public let permission: GoogleDrivePermissionEntity
    public let lastModified: Date
    
    public init(identifier: String,
                name: String,
                mimeType: EGoogleDriveFileMimeType,
                trashed: Bool,
                starred: Bool,
                shared: Bool,
                webContentLink: String,
                permission: GoogleDrivePermissionEntity,
                lastModified: Date) {
        self.identifier = identifier
        self.name = name
        self.mimeType = mimeType
        self.trashed = trashed
        self.starred = starred
        self.shared = shared
        self.webContentLink = webContentLink
        self.permission = permission
        self.lastModified = lastModified
    }
}
