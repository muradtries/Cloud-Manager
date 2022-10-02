//
//  GoogleDrivePermissionRepoProtocol.swift
//  Domain
//
//  Created by Murad on 19.09.22.
//

import Foundation
import Promises

public protocol GoogleDrivePermissionRepoProtocol {
    func manageAccessToFile(with fileID: String, permissionRole: EPermissionRole) -> Promise<Void>
    func removeAccessToFile(with fileID: String) -> Promise<Void>
}
