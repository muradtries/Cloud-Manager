//
//  MoveToTrashDropboxFileUseCase.swift
//  Domain
//
//  Created by Murad on 24.09.22.
//

import Foundation
import Promises

public class MoveToTrashDropboxFileUseCase {
    private let repo: DropboxRepoProtocol
    
    init(repo: DropboxRepoProtocol) {
        self.repo = repo
    }
    
    public func moveToTrashFile(path: String) -> Promise<Void> {
        self.repo.moveToTrashFile(path: path)
    }
}
