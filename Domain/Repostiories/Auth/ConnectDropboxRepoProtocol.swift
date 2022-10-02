//
//  ConnectDropboxRepoProtocol.swift
//  Domain
//
//  Created by Murad on 21.09.22.
//

import Foundation
import UIKit
import Promises

public protocol ConnectDropboxRepoProtocol {
    func signIn(presenting: UIViewController) -> Promise<Void>
    func disconnect()
}
