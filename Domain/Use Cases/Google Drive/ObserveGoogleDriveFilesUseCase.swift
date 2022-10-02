//
//  ObserveGoogleDriveFilesUseCase.swift
//  Domain
//
//  Created by Murad on 28.08.22.
//

import Foundation
import RxSwift

public class ObserveGoogleDriveFilesUseCase {
    private let repo: GoogleDriveRepoProtocol
    
    init(repo: GoogleDriveRepoProtocol) {
        self.repo = repo
    }
    
    public func observe(folderId: String) -> Observable<[GoogleDriveFileEntity]> {
        self.repo.observeFiles(folderId: folderId)
    }
}
