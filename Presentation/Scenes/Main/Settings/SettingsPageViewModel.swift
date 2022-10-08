//
//  SettingsViewModel.swift
//  Presentation
//
//  Created by Murad on 06.09.22.
//

import Foundation
import Promises
import Domain

class SettingsPageViewModel {
    
    func clearAllFilesCache() throws {
        let manager = FileManager.default
        
        let documentsURL: URL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        print("DOCUMENTS SUBDIR-S \(try documentsURL.subDirectories())")
        
        let downloadedDocumentsURL: URL = documentsURL.appendingPathComponent(".downloaded_files")
        
        print("DOCUMENTS SUBDIR-S \(try documentsURL.subDirectories())")
        
        try FileManager.default.removeItem(at: downloadedDocumentsURL)
        
        print("DOCUMENTS SUBDIR-S \(try documentsURL.subDirectories())")
    }
}
