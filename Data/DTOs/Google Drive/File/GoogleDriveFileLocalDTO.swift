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
    @Persisted var folderID: String = ""
    @Persisted var name: String = ""
    @Persisted var mimeType: String = ""
    @Persisted var trashed: Bool = false
    @Persisted var starred: Bool = false
    @Persisted var shared: Bool = false
    @Persisted var webContentLink: String = ""
    @Persisted var permission: GoogleDrivePermissionLocalDTO?
    @Persisted var lastModified: Date = Date()
    
    func setData(identifier: String,
                 folderID: String,
                 name: String,
                 mimeType: String,
                 trashed: Bool,
                 starred: Bool,
                 shared: Bool,
                 webContentLink: String,
                 permission: GoogleDrivePermissionLocalDTO,
                 lastModified: Date) {
        self.identifier = identifier
        self.folderID = folderID
        self.name = name
        self.mimeType = mimeType
        self.trashed = trashed
        self.starred = starred
        self.shared = shared
        self.webContentLink = webContentLink
        self.permission = permission
        self.lastModified = lastModified
    }
}
