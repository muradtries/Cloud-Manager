//
//  SyncGoogleDriveFilesUseCase.swift
//  Domain
//
//  Created by Murad on 28.08.22.
//

import Foundation
import Promises

public class SyncGoogleDriveFilesUseCase {
    private let repo: GoogleDriveRepoProtocol
    
    init(repo: GoogleDriveRepoProtocol) {
        self.repo = repo
    }
    
    public func sync(folderID: String) -> Promise<Void> {
        self.repo.syncFiles(folderID)
    }
}
