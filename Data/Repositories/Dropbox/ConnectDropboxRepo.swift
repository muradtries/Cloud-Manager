//
//  ConnectDropboxRepo.swift
//  Data
//
//  Created by Murad on 21.09.22.
//

import Foundation
import UIKit
import Domain
import Promises
import GoogleSignIn
import SwiftyDropbox

protocol ConnectDropboxRepoDelegate: AnyObject {
    func authIsComplete(result: DropboxOAuthResult)
}

extension UIApplication {
    public static var authSuccessPromise: Promise<Void> = .pending()
}

class ConnectDropboxRepo: ConnectDropboxRepoProtocol {
    
    let nc = NotificationCenter.default
    let signInConfig = GIDConfiguration(clientID: Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as! String)
    private weak var delegate: ConnectDropboxRepoDelegate?
    
    init() {
        print("CONNECT DROPBOX REPO IS INITIALIZED")
    }
    
    func signIn(presenting: UIViewController) -> Promise<Void> {
        
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: [], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: presenting,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
        

        UIApplication.authSuccessPromise = .pending()
        return UIApplication.authSuccessPromise
    }
    
    func disconnect() {
        print("Signed Out")
        DropboxClientsManager.unlinkClients()
        UserDefaults.standard.set(false, forKey: "connectedDropbox")
        UserDefaults.standard.synchronize()
        self.nc.post(name: Notification.Name("DisconnectedDropbox"), object: nil)
    }
    
    deinit {
        print("CONNECT DROPBOX REPO IS DEALLOCATED")
    }
}

