//
//  File.swift
//  Presentation
//
//  Created by Murad on 10.09.22.
//

import Foundation
import QuickLook

class File: NSObject, QLPreviewItem {
    var previewItemTitle: String?
    var previewItemURL: URL?
    
    init(previewItemTitle: String, previewItemURL: URL) {
        self.previewItemTitle = previewItemTitle
        self.previewItemURL = previewItemURL
    }
}

extension File {
    static func loadFile(fileIdentifier: String) throws -> URL? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let downloadedImagesPath = try documentsURL.subDirectories()[0]
        
        return try downloadedImagesPath.getFiles().filter { url in
            return (url.localizedName! as NSString).deletingPathExtension == fileIdentifier
        }
        .map { url in
            return url
        }[0]
    }
    
    static func checkFileExists(fileIdentifier: String) throws -> Bool {
        if try loadFile(fileIdentifier: fileIdentifier) != nil {
            return true
        } else {
            return false
        }
    }
}
