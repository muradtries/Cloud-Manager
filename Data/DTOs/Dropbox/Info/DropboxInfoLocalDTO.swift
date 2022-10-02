//
//  DropboxInfoLocalDTO.swift
//  Data
//
//  Created by Murad on 22.09.22.
//

import Foundation
import Realm
import RealmSwift

public class DropboxInfoLocalDTO: Object {
    @Persisted(primaryKey: true) var identifier: String = UUID().uuidString
    @Persisted var ownerDisplayName: String = ""
    @Persisted var profilePhotoLink: String = ""
    @Persisted var ownerEmailAdress: String = ""
    @Persisted var storageLimit: String = ""
    @Persisted var storageUsage: String = ""
}
