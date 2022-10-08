//
//  Configuration.swift
//  Data
//
//  Created by Murad on 08.10.22.
//

import Foundation

public struct Configuration {
    var getGoogleDriveScopes: [String] {
        get {
            let driveScopes = ["https://www.googleapis.com/auth/drive"]
            return driveScopes
        }
    }
}
