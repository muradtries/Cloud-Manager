//
//  MoveToTrashUseCase.swift
//  Domain
//
//  Created by Murad on 15.09.22.
//

import Foundation
import Promises

public class MoveToTrashUseCase {
    private let repo: GoogleDriveRepoProtocol
    
    init(repo: GoogleDriveRepoProtocol) {
        self.repo = repo
    }
    
    public func moveToTrashFile(with fileName: String, fileID: String) -> Promise<Void> {
        self.repo.moveToTrashFile(with: fileName, fileID: fileID)
    }
}
