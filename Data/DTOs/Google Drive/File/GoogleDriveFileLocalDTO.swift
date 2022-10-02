//
//  GoogleDriveFileLocalDTO.swift
//  Data
//
//  Created by Murad on 01.09.22.
//

import Foundation
import Realm
import RealmSwift

public class GoogleDriveFileLocalDTO: Object {
    @Persisted(primaryKey: true) var identifier: String = UUID().uuidString
    @Persisted var folderId: String = ""
    @Persisted var name: String = ""
    @Persisted var mimeType: String = ""
    @Persisted var trashed: Bool = false
    @Persisted var starred: Bool = false
    @Persisted var shared: Bool = false
    @Persisted var webContentLink: String = ""
    @Persisted var permission: GoogleDrivePermissionLocalDTO?
    @Persisted var lastModified: Date = Date()
}
