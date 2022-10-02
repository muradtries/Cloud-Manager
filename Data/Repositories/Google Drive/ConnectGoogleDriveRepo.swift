//
//  SignInWithGoogleRepo.swift
//  Data
//
//  Created by Murad on 03.09.22.
//

import Foundation
import UIKit
import Domain
import Promises
import GoogleSignIn

class ConnectGoogleDriveRepo: ConnectGoogleDriveRepoProtocol {
    
    let nc = NotificationCenter.default
    let signInConfig = GIDConfiguration(clientID: Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as! String)
    
    init() {
        print("CONNECT GOOGLE DRIVE REPO IS INITIALIZED")
    }
    
    func signIn(presenting: UIViewController) -> Promise<Void> {
        let promise = Promise<Void>.pending()
        
        let driveScope: [String] = ["https://www.googleapis.com/auth/drive"]
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: presenting, hint: "", additionalScopes: driveScope) { user, error in
            if let error = error {
                print("Oh an Error occured 🤨")
                promise.reject(error)
            }
            
            guard let user = user else { return }
            
            print("Sign in successful ✅")
            
            UserDefaults.standard.set(true, forKey: "connectedGoogleDrive")
            UserDefaults.standard.synchronize()
            self.nc.post(name: Notification.Name("ConnectedGoogleDrive"), object: nil)
            
            print(String(describing: user.profile?.email))
            print(String(describing: user.profile?.name))
            print(String(describing: user.authentication.fetcherAuthorizer()))
            print(String(describing: user.grantedScopes))
            print(String(describing: user.authentication.accessToken))
            
            promise.fulfill(Void())
        }
        
        return promise
    }
    
    func disconnect() {
        print("Signed Out")
        GIDSignIn.sharedInstance.disconnect { error in
            print("Error value: \(String(describing: error))")
        }
        UserDefaults.standard.set(false, forKey: "connectedGoogleDrive")
        UserDefaults.standard.synchronize()
        self.nc.post(name: Notification.Name("DisconnectedGoogleDrive"), object: nil)
    }
    
    deinit {
        print("CONNECT GOOGLE DRIVE REPO IS DEALLOCATED")
    }
}
