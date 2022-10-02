//
//  UploadDropboxFileUseCase.swift
//  Domain
//
//  Created by Murad on 23.09.22.
//

import Foundation
import RxSwift
import Promises

public class UploadDropboxFileUseCase {
    private let repo: DropboxRepoProtocol
    
    init(repo: DropboxRepoProtocol) {
        self.repo = repo
    }
    
    public func uploadFile(to folderPath: String, with fileName: String, data: Data) -> (Promise<Void>, Observable<UploadProgressEntity>) {
        self.repo.uploadFile(to: folderPath, with: fileName, data: data)
    }
}
