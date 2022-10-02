//
//  UpdateFileNameUseCase.swift
//  Domain
//
//  Created by Murad on 17.09.22.
//

import Foundation
import Promises

public class UpdateFileNameUseCase {
    private let repo: GoogleDriveRepoProtocol
    
    init(repo: GoogleDriveRepoProtocol) {
        self.repo = repo
    }
    
    public func updateFileName(to newName: String, fileID: String) -> Promise<Void> {
        self.repo.updateFileName(to: newName, fileID: fileID)
    }
}
