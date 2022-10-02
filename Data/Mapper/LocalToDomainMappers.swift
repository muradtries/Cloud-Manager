//
//  LocalToDomainMappers.swift
//  Data
//
//  Created by Murad on 06.09.22.
//

import Foundation
import Domain

extension GoogleDriveFileLocalDTO {
    var toDomain: GoogleDriveFileEntity {
        return GoogleDriveFileEntity(identifier: self.identifier,
                                     name: name,
                                     mimeType: self.getMimeType,
                                     trashed: self.trashed,
                                     starred: self.starred,
                                     shared: self.shared,
                                     webContentLink: self.webContentLink,
                                     permission: GoogleDrivePermissionEntity(type: self.permission!.type, role: self.getPermissionRole),
                                     lastModified: self.lastModified)
    }
    
    var getMimeType: EGoogleDriveFileMimeType {
        switch self.mimeType {
        case "application/vnd.google-apps.folder":
            return EGoogleDriveFileMimeType.folder
        case "image/jpeg":
            return EGoogleDriveFileMimeType.image(".jpeg")
        case "image/jpg":
            return EGoogleDriveFileMimeType.image(".jpg")
        case "image/png":
            return EGoogleDriveFileMimeType.image(".png")
        case "application/pdf":
            return EGoogleDriveFileMimeType.pdf(".pdf")
        case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
            return EGoogleDriveFileMimeType.spreadSheet(".xlsx")
        case "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
            return EGoogleDriveFileMimeType.document(".docx")
        case "video/mp4":
            return EGoogleDriveFileMimeType.video(".mp4")
        case "video/m4a":
            return EGoogleDriveFileMimeType.video(".m4a")
        case "docx":
            return EGoogleDriveFileMimeType.document(".doc")
        default:
            return EGoogleDriveFileMimeType.document(".txt")
        }
    }
    
    var getPermissionRole: EPermissionRole {
        switch self.permission!.role {
        case "owner":
            return .owner
        case "reader":
            return .viewer
        case "writer":
            return .editor
        case "commenter":
            return .commenter
        default:
            return .viewer
        }
    }
}

extension DropboxFileLocalDTO {
    var toDomain: DropboxFileEntity {
        return DropboxFileEntity(identifier: self.identifier,
                                 parentFolderPath: self.parentFolderPath,
                                 name: self.name,
                                 lastModified: self.lastModified,
                                 path: self.path,
                                 mimeType: self.getMimeType)
    }
    
    var getMimeType: EDropboxFileMimeType {
        switch self.mimeType {
        case "folder":
            return EDropboxFileMimeType.folder
        case "jpeg":
            return EDropboxFileMimeType.image(".jpeg")
        case "jpg":
            return EDropboxFileMimeType.image(".jpg")
        case "png":
            return EDropboxFileMimeType.image(".png")
        case "pdf":
            return EDropboxFileMimeType.pdf(".pdf")
        case "xlsx":
            return EDropboxFileMimeType.spreadSheet(".xlsx")
        case "docx":
            return EDropboxFileMimeType.document(".docx")
        case "mp4":
            return EDropboxFileMimeType.video(".mp4")
        case "m4a":
            return EDropboxFileMimeType.video(".m4a")
        default:
            return EDropboxFileMimeType.document(".txt")
        }
    }
}

extension GoogleDriveInfoLocalDTO {
    var toDomain: GoogleDriveInfoEntity {
        return GoogleDriveInfoEntity(ownerDisplayName: self.ownerDisplayName,
                                     profilePhotoLink: self.profilePhotoLink,
                                     ownerEmailAdress: self.ownerEmailAdress,
                                     storageLimit: self.storageLimit,
                                     storageUsage: self.storageUsage,
                                     storageUsageInDrive: self.storageUsageInDrive,
                                     storageUsageInTrash: self.storageUsageInTrash)
    }
}

extension DropboxInfoLocalDTO {
    var toDomain: DropboxInfoEntity {
        return DropboxInfoEntity(ownerDisplayName: self.ownerDisplayName,
                                 profilePhotoLink: self.profilePhotoLink,
                                 ownerEmailAdress: self.ownerEmailAdress,
                                 storageLimit: self.storageLimit,
                                 storageUsage: self.storageUsage)
    }
}
