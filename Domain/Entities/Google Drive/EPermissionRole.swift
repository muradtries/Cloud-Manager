//
//  EPermissionRole.swift
//  Domain
//
//  Created by Murad on 20.09.22.
//

import Foundation

public enum EPermissionRole: String {
    case owner
    case viewer
    case commenter
    case editor
    
    public func toString() -> String {
        switch self {
        case .owner:
            return "owner"
        case .viewer:
            return "reader"
        case .commenter:
            return "commenter"
        case .editor:
            return "writer"
        }
    }
}
