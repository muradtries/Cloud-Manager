//
//  ObserveGoogleDriveInfoUseCase.swift
//  Domain
//
//  Created by Murad on 09.09.22.
//

import Foundation
import RxSwift

public class ObserveGoogleDriveInfoUseCase {
    private let repo: GoogleDriveRepoProtocol
    
    init(repo: GoogleDriveRepoProtocol) {
        self.repo = repo
    }
    
    public func observeInfo() -> Observable<GoogleDriveInfoEntity> {
        self.repo.observeGoogleDriveInfo()
    }
}
