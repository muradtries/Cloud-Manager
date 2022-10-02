//
//  DropboxFileLocalDTO.swift
//  Data
//
//  Created by Murad on 22.09.22.
//

import Foundation
import Realm
import RealmSwift

public class DropboxFileLocalDTO: Object {
    @Persisted(primaryKey: true) var identifier: String = UUID().uuidString
    @Persisted var parentFolderPath: String = ""
    @Persisted var name: String = ""
    @Persisted var lastModified: Date = Date()
    @Persisted var path: String = ""
    @Persisted var mimeType: String = ""
}
