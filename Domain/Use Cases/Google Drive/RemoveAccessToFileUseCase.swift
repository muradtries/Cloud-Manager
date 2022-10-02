//
//  RemoveAccessToFileUseCase.swift
//  Domain
//
//  Created by Murad on 19.09.22.
//

import Foundation
import Promises

public class RemoveAccessToFileUseCase {
    private let repo: GoogleDrivePermissionRepoProtocol
    
    init(repo: GoogleDrivePermissionRepoProtocol) {
        self.repo = repo
    }
    
    public func removeAccessToFile(with fileID: String) -> Promise<Void> {
        repo.removeAccessToFile(with: fileID)
    }
}
