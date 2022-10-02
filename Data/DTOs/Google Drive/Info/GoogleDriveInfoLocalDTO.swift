//
//  GoogleDriveInfoLocalDTO.swift
//  Data
//
//  Created by Murad on 09.09.22.
//

import Foundation
import Realm
import RealmSwift

public class GoogleDriveInfoLocalDTO: Object {
    @Persisted(primaryKey: true) var identifier: String = UUID().uuidString
    @Persisted var ownerDisplayName: String = ""
    @Persisted var profilePhotoLink: String = ""
    @Persisted var ownerEmailAdress: String = ""
    @Persisted var storageLimit: String = ""
    @Persisted var storageUsage: String = ""
    @Persisted var storageUsageInDrive: String = ""
    @Persisted var storageUsageInTrash: String = ""
}
