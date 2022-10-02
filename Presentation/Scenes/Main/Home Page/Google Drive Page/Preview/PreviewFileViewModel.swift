//
//  PreviewFileViewModel.swift
//  Presentation
//
//  Created by Murad on 06.09.22.
//

import Foundation
import Promises
import Domain

public class PreviewFileViewModel {
    
    var file: GoogleDriveFileEntity
    
    lazy var previewFileURL: URL? = {
        do {
            let previewFileURL = try File.loadFile(fileIdentifier: file.identifier)
            return previewFileURL
        } catch {
            print("ERROR OCCURED: \(error.localizedDescription)")
        }
        
        return nil
    }()
    
    lazy var previewFile: File = File(previewItemTitle: file.name, previewItemURL: previewFileURL ?? URL(fileURLWithPath: ""))
    
    public let downloadFileUseCase: DownloadGoogleDriveFileUseCase
    
    init(downloadFileUseCase: DownloadGoogleDriveFileUseCase,
         file: GoogleDriveFileEntity) {
        self.downloadFileUseCase = downloadFileUseCase
        self.file = file
    }
    
    func checkFileExists() -> Bool {
        let manager = FileManager.default
        
        print(file.mimeType.toFileExtension)
        
        let documentsURL: URL = try! manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let downloadedDocumentsPath: URL = documentsURL.appendingPathComponent(".downloaded_files")
        
        let downloadedDocumentPath: URL = downloadedDocumentsPath.appendingPathComponent("\(file.identifier)\(file.mimeType.toFileExtension)")
        
        print(downloadedDocumentPath.relativePath)
        
        if manager.fileExists(atPath: downloadedDocumentPath.relativePath) {
            return true
        } else {
            return false
        }
    }
    
    func downloadFile() -> Promise<Data> {
        return self.downloadFileUseCase.download(file: file)
    }
}
