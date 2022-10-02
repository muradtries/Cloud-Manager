//
//  GoogleDrivePermissionLocalDTO.swift
//  Data
//
//  Created by Murad on 20.09.22.
//

import Foundation
import Realm
import RealmSwift

public class GoogleDrivePermissionLocalDTO: Object {
    @Persisted var type: String = ""
    @Persisted var role: String = ""
    
    convenience init(type: String, role: String) {
        self.init()
        self.type = type
        self.role = role
    }
}
