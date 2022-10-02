//
//  ObserveDropboxFilesUseCase.swift
//  Domain
//
//  Created by Murad on 22.09.22.
//

import Foundation
import RxSwift

public class ObserveDropboxFilesUseCase {
    private let repo: DropboxRepoProtocol
    
    init(repo: DropboxRepoProtocol) {
        self.repo = repo
    }
    
    public func observe(folderPath: String) -> Observable<[DropboxFileEntity]> {
        self.repo.observeFiles(folderPath: folderPath)
    }
}
