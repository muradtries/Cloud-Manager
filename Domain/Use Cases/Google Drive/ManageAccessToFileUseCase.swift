//
//  ManageAccessToFileUseCase.swift
//  Domain
//
//  Created by Murad on 19.09.22.
//

import Foundation
import Promises

public class ManageAccessToFileUseCase {
    private let repo: GoogleDrivePermissionRepoProtocol
    
    init(repo: GoogleDrivePermissionRepoProtocol) {
        self.repo = repo
    }
    
    public func manageAccessToFile(with fileID: String, permissionRole: EPermissionRole) -> Promise<Void> {
        self.repo.manageAccessToFile(with: fileID, permissionRole: permissionRole)
    }
}
