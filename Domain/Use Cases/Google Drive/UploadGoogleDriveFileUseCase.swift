//
//  UploadGoogleDriveFileUseCase.swift
//  Domain
//
//  Created by Murad on 12.09.22.
//

import Foundation
import RxSwift
import Promises

public class UploadGoogleDriveFileUseCase {
    private let repo: GoogleDriveRepoProtocol
    
    init(repo: GoogleDriveRepoProtocol) {
        self.repo = repo
    }
    
    public func uploadFile(with fileName: String, folderID: String, data: Data, mimeType: EGoogleDriveFileMimeType) -> (Promise<Void>, Observable<UploadProgressEntity>) {
        self.repo.uploadFile(with: fileName, folderID: folderID, data: data, mimeType: mimeType)
    }
}
