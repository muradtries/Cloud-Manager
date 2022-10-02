//
//  SyncGoogleDriveInfoUseCase.swift
//  Domain
//
//  Created by Murad on 09.09.22.
//

import Foundation
import Promises

public class SyncGoogleDriveInfoUseCase {
    private let repo: GoogleDriveRepoProtocol
    
    init(repo: GoogleDriveRepoProtocol) {
        self.repo = repo
    }
    
    public func syncInfo() -> Promise<Void> {
        self.repo.syncGoogleDriveInfo()
    }
}
