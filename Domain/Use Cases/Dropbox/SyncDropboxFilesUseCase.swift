//
//  SyncDropboxFilesUseCase.swift
//  Domain
//
//  Created by M/D Student - Murad A. on 21.09.22.
//

import Foundation
import Promises

public class SyncDropboxFilesUseCase {
    private let repo: DropboxRepoProtocol
    
    init(repo: DropboxRepoProtocol) {
        self.repo = repo
    }
    
    public func sync(folderPath: String) -> Promise<Void> {
        self.repo.syncFiles(folderPath)
    }
}
