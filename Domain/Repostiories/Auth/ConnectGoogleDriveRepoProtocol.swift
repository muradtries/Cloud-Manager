//
//  ConnectGoogleDriveRepoProtocol.swift
//  Domain
//
//  Created by Murad on 03.09.22.
//

import Foundation
import UIKit
import Promises

public protocol ConnectGoogleDriveRepoProtocol {
    func signIn(presenting: UIViewController) -> Promise<Void>
    func disconnect()
}
