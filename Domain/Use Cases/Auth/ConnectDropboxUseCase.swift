//
//  ConnectDropboxUseCase.swift
//  Domain
//
//  Created by Murad on 21.09.22.
//

import Foundation
import Promises
import UIKit

public class ConnectDropboxUseCase {
    private let repo: ConnectDropboxRepoProtocol
    
    init(repo: ConnectDropboxRepoProtocol) {
        self.repo = repo
    }
    
    public func signIn(presenting: UIViewController) -> Promise<Void> {
        self.repo.signIn(presenting: presenting)
    }
    
    public func disconnect() {
        self.repo.disconnect()
    }
}
