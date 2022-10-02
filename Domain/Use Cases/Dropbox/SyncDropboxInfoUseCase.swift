//
//  SyncDropboxInfoUseCase.swift
//  Domain
//
//  Created by Murad on 22.09.22.
//

import Foundation
import Promises

public class SyncDropboxInfoUseCase {
    private let repo: DropboxRepoProtocol
    
    init(repo: DropboxRepoProtocol) {
        self.repo = repo
    }
    
    public func syncInfo() -> Promise<Void> {
        self.repo.syncDropboxInfo()
    }
}
