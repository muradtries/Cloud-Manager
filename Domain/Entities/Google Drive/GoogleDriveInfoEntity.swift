//
//  GoogleDriveEntity.swift
//  Domain
//
//  Created by Murad on 08.09.22.
//

import Foundation

public struct GoogleDriveInfoEntity {
    public let ownerDisplayName: String
    public let profilePhotoLink: String
    public let ownerEmailAdress: String
    public let storageLimit: String
    public let storageUsage: String
    public let storageUsageInDrive: String
    public let storageUsageInTrash: String
    
    public init(ownerDisplayName: String,
                profilePhotoLink: String,
                ownerEmailAdress: String,
                storageLimit: String,
                storageUsage: String,
                storageUsageInDrive: String,
                storageUsageInTrash: String) {
        self.ownerDisplayName = ownerDisplayName
        self.profilePhotoLink = profilePhotoLink
        self.ownerEmailAdress = ownerEmailAdress
        self.storageLimit = storageLimit
        self.storageUsage = storageUsage
        self.storageUsageInDrive = storageUsageInDrive
        self.storageUsageInTrash = storageUsageInTrash
    }
}
