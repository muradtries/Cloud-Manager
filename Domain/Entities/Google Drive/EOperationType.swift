//
//  EOperationType.swift
//  Domain
//
//  Created by Murad on 20.09.22.
//

import Foundation

public enum EOperationType {
    case rename
    case updateAccess(EPermissionRole)
    case removeAccess
    case moveToTrash
}
