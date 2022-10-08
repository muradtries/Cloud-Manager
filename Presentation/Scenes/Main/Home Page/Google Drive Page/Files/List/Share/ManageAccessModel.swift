//
//  ManageAccessModel.swift
//  Presentation
//
//  Created by Murad on 08.10.22.
//

import Domain

enum AccessOptions {
    case restricted
    case anyoneWithLink(EPermissionRole)
    
    var title: String {
        get {
            switch self {
            case .restricted:
                return "Restricted"
            case .anyoneWithLink:
                return "Anyone with link"
            }
        }
    }
}

enum AccessRoles: String {
    case viewer = "Viewer"
    case editor = "Editor"
    case commenter = "Commenter"
}
