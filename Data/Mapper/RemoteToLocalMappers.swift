//
//  RemoteToLocalMappers.swift
//  Data
//
//  Created by Murad on 09.09.22.
//

import Foundation

extension GoogleDriveInfoRemoteDTO {
    var toLocal: GoogleDriveInfoLocalDTO {
        let dto = GoogleDriveInfoLocalDTO()
        dto.ownerDisplayName = self.ownerDisplayName
        dto.profilePhotoLink = self.profilePhotoLink
        dto.ownerEmailAdress = self.ownerEmailAdress
        dto.storageLimit = self.storageLimit
        dto.storageUsage = self.storageUsage
        dto.storageUsageInDrive = self.storageUsageInDrive
        dto.storageUsageInTrash = self.storageUsageInTrash
        return dto
    }
}

extension DropboxInfoRemoteDTO {
    var toLocal: DropboxInfoLocalDTO {
        let dto = DropboxInfoLocalDTO()
        dto.ownerDisplayName = self.ownerDisplayName
        dto.profilePhotoLink = self.profilePhotoLink
        dto.ownerEmailAdress = self.ownerEmailAdress
        dto.storageLimit = self.storageLimit
        dto.storageUsage = self.storageUsage
        return dto
    }
}

extension GoogleDriveFileRemoteDTO {
    func toLocal(folderID: String) -> GoogleDriveFileLocalDTO {
        return GoogleDriveFileLocalDTO(identifier: self.identifier,
                                       folderID: folderID,
                                       name: self.name,
                                       mimeType: self.mimeType,
                                       trashed: self.trashed,
                                       starred: self.starred,
                                       shared: self.shared,
                                       webContentLink: self.webContentLink,
                                       permission: GoogleDrivePermissionLocalDTO.init(type: self.permission.type, role: self.permission.role),
                                       lastModified: self.lastModified)
    }
}
