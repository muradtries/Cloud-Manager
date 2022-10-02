//
//  GoogleDriveFileRemoteDTO.swift
//  Data
//
//  Created by Murad on 01.09.22.
//

import Foundation

public struct GoogleDriveFileRemoteDTO {
    let identifier: String
    let name: String
    let mimeType: String
    let trashed: Bool
    let starred: Bool
    let shared: Bool
    let webContentLink: String
    let permission: GoogleDrivePermissionRemoteDTO
    let lastModified: Date
}
