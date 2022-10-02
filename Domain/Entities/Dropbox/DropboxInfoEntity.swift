//
//  DropboxInfoEntity.swift
//  Domain
//
//  Created by Murad on 22.09.22.
//

import Foundation

public struct DropboxInfoEntity {
    public let ownerDisplayName: String
    public let profilePhotoLink: String
    public let ownerEmailAdress: String
    public let storageLimit: String
    public let storageUsage: String
    
    public init(ownerDisplayName: String,
                profilePhotoLink: String,
                ownerEmailAdress: String,
                storageLimit: String,
                storageUsage: String) {
        self.ownerDisplayName = ownerDisplayName
        self.profilePhotoLink = profilePhotoLink
        self.ownerEmailAdress = ownerEmailAdress
        self.storageLimit = storageLimit
        self.storageUsage = storageUsage
    }
}
