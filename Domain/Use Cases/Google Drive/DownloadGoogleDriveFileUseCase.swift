//
//  DownloadGoogleDriveFileUseCase.swift
//  Domain
//
//  Created by Murad on 06.09.22.
//

import Foundation
import Promises

public class DownloadGoogleDriveFileUseCase {
    private let repo: GoogleDriveRepoProtocol
    
    init(repo: GoogleDriveRepoProtocol) {
        self.repo = repo
    }
    
    public func download(file: GoogleDriveFileEntity) -> Promise<Data> {
        return self.repo.download(file: file)
    }
}
