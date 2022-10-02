//
//  RestoreUserUseCase.swift
//  Domain
//
//  Created by M/D Student - Murad A. on 06.09.22.
//

import Foundation
import Promises

public class RestoreUserUseCase {
    
    private let repo: GoogleDriveRepoProtocol
    
    init(repo: GoogleDriveRepoProtocol) {
        self.repo = repo
    }
    
    public var execute: Promise<Void> {
        self.repo.restoreUser()
    }
}
