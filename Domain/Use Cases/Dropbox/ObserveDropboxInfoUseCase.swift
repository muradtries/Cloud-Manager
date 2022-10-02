//
//  ObserveDropboxInfoUseCase.swift
//  Domain
//
//  Created by Murad on 22.09.22.
//

import Foundation
import RxSwift

public class ObserveDropboxInfoUseCase {
    private let repo: DropboxRepoProtocol
    
    init(repo: DropboxRepoProtocol) {
        self.repo = repo
    }
    
    public func observeInfo() -> Observable<DropboxInfoEntity> {
        self.repo.observeDropboxInfo()
    }
}
