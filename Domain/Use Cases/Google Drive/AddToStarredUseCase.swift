//
//  AddToStarredUseCase.swift
//  Domain
//
//  Created by Murad on 24.09.22.
//

import Foundation
import Promises

public class AddToStarredUseCase {
    private let repo: GoogleDriveRepoProtocol
    
    init(repo: GoogleDriveRepoProtocol) {
        self.repo = repo
    }
    
    public func addToStarred(with fileID: String, starred: Bool) -> Promise<Void> {
        self.repo.addToStarred(fileID: fileID, starred: starred)
    }
}
