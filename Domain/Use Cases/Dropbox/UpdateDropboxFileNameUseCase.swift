//
//  UpdateDropboxFileNameUseCase.swift
//  Domain
//
//  Created by Murad on 24.09.22.
//

import Foundation
import Promises

public class UpdateDropboxFileNameUseCase {
    private let repo: DropboxRepoProtocol
    
    init(repo: DropboxRepoProtocol) {
        self.repo = repo
    }
    
    public func updateFileName(from previousName: String, to newName: String, parentFolderPath: String) -> Promise<Void> {
        self.repo.updateFileName(from: previousName, to: newName, parentFolderPath: parentFolderPath)
    }
}
