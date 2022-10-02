//
//  DropboxViewModel.swift
//  Presentation
//
//  Created by M/D Student - Murad A. on 21.09.22.
//

import Foundation
import RxSwift
import Promises
import Domain

protocol DropboxNavigationDelegate: AnyObject {
    func goToDropboxFolderVC(folderPath: String, folderName: String)
    func goToPreviewFileVC(file: DropboxFileEntity)
    func goToPreviewImage(file: DropboxFileEntity)
}

protocol DropboxPresentationDelegate: AnyObject {
    func presentPickerOptions(viewController: DropboxController)
    func presentImagePicker(viewController: DropboxController)
    func presentDocumentPicker(viewController: DropboxController)
    func presentMoreOptions(viewController: DropboxController, file: DropboxFileEntity)
}

class DropboxViewModel {
    
    weak var navigationDelegate: DropboxNavigationDelegate?
    weak var presentationDelegate: DropboxPresentationDelegate?
    var folderPath: String
    
    let syncDropboxFilesUseCase: SyncDropboxFilesUseCase
    let observeDropboxFileUseCase: ObserveDropboxFilesUseCase
    let downloadFileUseCase: DownloadDropboxFileUseCase
    let uploadFileUseCase: UploadDropboxFileUseCase
    let updateFileNameUseCase: UpdateDropboxFileNameUseCase
    let moveToTrashUseCase: MoveToTrashDropboxFileUseCase
    
    init(syncDropboxFilesUseCase: SyncDropboxFilesUseCase,
         observeDropboxFileUseCase: ObserveDropboxFilesUseCase,
         downloadFileUseCase: DownloadDropboxFileUseCase,
         uploadFileUseCase: UploadDropboxFileUseCase,
         updateFileNameUseCase: UpdateDropboxFileNameUseCase,
         moveToTrashUseCase: MoveToTrashDropboxFileUseCase,
         folderPath: String) {
        self.syncDropboxFilesUseCase = syncDropboxFilesUseCase
        self.observeDropboxFileUseCase = observeDropboxFileUseCase
        self.downloadFileUseCase = downloadFileUseCase
        self.uploadFileUseCase = uploadFileUseCase
        self.updateFileNameUseCase = updateFileNameUseCase
        self.moveToTrashUseCase = moveToTrashUseCase
        self.folderPath = folderPath
    }
    
    deinit {
        print("DROPBOX VM DEALLOCATED")
    }
    
    func syncFiles() -> Promise<Void> {
        syncDropboxFilesUseCase.sync(folderPath: folderPath)
    }
    
    func observeFiles() -> Observable<[DropboxFileEntity]> {
        observeDropboxFileUseCase.observe(folderPath: folderPath)
            .observe(on: MainScheduler.instance)
    }
    
    func goToFolderVC(fileID: String, fileName: String) {
        self.navigationDelegate?.goToDropboxFolderVC(folderPath: fileID, folderName: fileName)
    }
    
    func goToPreviewFileVC(file: DropboxFileEntity) {
        self.navigationDelegate?.goToPreviewFileVC(file: file)
    }
    
    func goToPreviewImage(file: DropboxFileEntity) {
        self.navigationDelegate?.goToPreviewImage(file: file)
    }
    
    func uploadFile(to folderPath: String, with fileName: String, data: Data) -> (Promise<Void>, Observable<UploadProgressEntity>) {
        self.uploadFileUseCase.uploadFile(to: folderPath, with: fileName, data: data)
    }
    
    func updateFileName(from previousName: String, to newName: String, parentFolderPath: String) -> Promise<Void> {
        self.updateFileNameUseCase.updateFileName(from: previousName, to: newName, parentFolderPath: parentFolderPath)
    }
    
    func moveToTrash(path: String) {
        self.moveToTrashUseCase.moveToTrashFile(path: path).then { _ in
            print("FILE MOVED TO TRASH")
            self.syncFiles().then { _ in
                print("Synced Files 🔄")
            }
        }
    }
    
    func presentPickerOptions(viewController: DropboxController) {
        self.presentationDelegate?.presentPickerOptions(viewController: viewController)
    }
    
    func presentImagePicker(viewController: DropboxController) {
        self.presentationDelegate?.presentImagePicker(viewController: viewController)
    }
    
    func presentDocumentPicker(viewController: DropboxController) {
        self.presentationDelegate?.presentDocumentPicker(viewController: viewController)
    }
    
    func presentMoreOptions(viewController: DropboxController, file: DropboxFileEntity) {
        self.presentationDelegate?.presentMoreOptions(viewController: viewController, file: file)
    }
}

extension DropboxViewModel {
    func prepareMediaForUpload(url: URL) -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["fileName"] = url.lastPathComponent
        dict["fileExtension"] = url.pathExtension
        url.startAccessingSecurityScopedResource()
        dict["fileData"] = try! Data(contentsOf: url)
        url.startAccessingSecurityScopedResource()
        
        return dict
    }
}
