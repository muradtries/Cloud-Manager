//
//  DomainToRemoteMappers.swift
//  Data
//
//  Created by M/D Student - Murad A. on 10.09.22.
//

import Foundation
import Domain

extension GoogleDriveFileEntity {
    var toRemote: GoogleDriveFileRemoteDTO {
        GoogleDriveFileRemoteDTO(
            identifier: self.identifier,
            name: self.name,
            mimeType: self.mimeType.toFileExtension,
            trashed: self.trashed,
            starred: self.starred,
            shared: self.shared,
            webContentLink: self.webContentLink,
            permission: GoogleDrivePermissionRemoteDTO(type: self.permission.type, role: self.permission.role.toString()),
            lastModified: self.lastModified)
    }
}

extension DropboxFileEntity {
    var toRemote: DropboxFileRemoteDTO {
        DropboxFileRemoteDTO(identifier: self.identifier,
                             name: self.name,
                             lastModified: self.lastModified,
                             path: self.path,
                             mimeType: self.mimeType.toFileExtension)
    }
}
