//
//  DownloadDropboxFileUseCase.swift
//  Domain
//
//  Created by Murad on 23.09.22.
//

import Foundation
import Promises

public class DownloadDropboxFileUseCase {
    private let repo: DropboxRepoProtocol
    
    init(repo: DropboxRepoProtocol) {
        self.repo = repo
    }
    
    public func downloadFile(in folderPath: String, file: DropboxFileEntity) -> Promise<Data> {
        self.repo.downloadFile(in: folderPath, file: file)
    }
}
