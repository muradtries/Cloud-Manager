//
//  GoogleDrivePermissionEntity.swift
//  Domain
//
//  Created by Murad on 19.09.22.
//

import Foundation

public struct GoogleDrivePermissionEntity {
    public let type: String
    public let role: EPermissionRole
    
    public init(type: String, role: EPermissionRole) {
        self.type = type
        self.role = role
    }
}
