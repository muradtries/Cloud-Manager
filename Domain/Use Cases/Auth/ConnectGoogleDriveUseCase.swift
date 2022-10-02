//
//  SignInWithGoogleUseCase.swift
//  Domain
//
//  Created by Murad on 02.09.22.
//

import Foundation
import Promises
import UIKit

public class ConnectGoogleDriveUseCase {
    private let repo: ConnectGoogleDriveRepoProtocol
    
    init(repo: ConnectGoogleDriveRepoProtocol) {
        self.repo = repo
    }
    
    public func signIn(presenting: UIViewController) -> Promise<Void> {
        self.repo.signIn(presenting: presenting)
    }
    
    public func disconnect() {
        self.repo.disconnect()
    }
}
