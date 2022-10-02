//
//  GoogleDriveViewModel.swift
//  Presentation
//
//  Created by Murad on 30.08.22.
//

import Foundation
import Domain
import Promises
import RxSwift
import UIKit

protocol GoogleDriveNavigationDelegate: AnyObject {
    func goToFolderVC(folderID: String, folderName: String)
    func goToPreviewFileVC(file: GoogleDriveFileEntity)
    func goToPreviewImage(file: GoogleDriveFileEntity)
}

protocol GoogleDrivePresentationDelegate: AnyObject {
    func presentPickerOptions(viewController: GoogleDriveController)
    func presentImagePicker(viewController: GoogleDriveController)
    func presentDocumentPicker(viewController: GoogleDriveController)
    func presentMoreOptions(viewController: GoogleDriveController, file: GoogleDriveFileEntity)
    func presentManageAccessVC(file: GoogleDriveFileEntity, viewController: GoogleDriveController)
}

public class GoogleDriveViewModel {
    
    weak var navigationDelegate: GoogleDriveNavigationDelegate?
    weak var presentationDelegate: GoogleDrivePresentationDelegate?
    var folderID: String
    
    public let observeGoogleDriveFilesUseCase: ObserveGoogleDriveFilesUseCase
    public let syncGoogleDriveFilesUseCase: SyncGoogleDriveFilesUseCase
    public let downloadFileUseCase: DownloadGoogleDriveFileUseCase
    public let uploadFileUseCase: UploadGoogleDriveFileUseCase
    public let moveToTrashUseCase: MoveToTrashUseCase
    public let updateFileNameUseCase: UpdateFileNameUseCase
    public let addToStarredUseCase: AddToStarredUseCase
    
    lazy var downloadedFilesURLs: [URL] = {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let downloadedImagesPath = try! documentsURL.subDirectories()[0]
        return try! downloadedImagesPath.getFiles()
    }()
    
    init(observeGoogleDriveFilesUseCase: ObserveGoogleDriveFilesUseCase,
         syncGoogleDriveFilesUseCase: SyncGoogleDriveFilesUseCase,
         downloadFileUseCase: DownloadGoogleDriveFileUseCase,
         uploadFileUseCase: UploadGoogleDriveFileUseCase,
         updateFileNameUseCase: UpdateFileNameUseCase,
         moveToTrashUseCase: MoveToTrashUseCase,
         addToStarredUseCase: AddToStarredUseCase,
         folderID: String) {
        self.observeGoogleDriveFilesUseCase = observeGoogleDriveFilesUseCase
        self.syncGoogleDriveFilesUseCase = syncGoogleDriveFilesUseCase
        self.folderID = folderID
        self.downloadFileUseCase = downloadFileUseCase
        self.uploadFileUseCase = uploadFileUseCase
        self.updateFileNameUseCase = updateFileNameUseCase
        self.moveToTrashUseCase = moveToTrashUseCase
        self.addToStarredUseCase = addToStarredUseCase
    }
    
    deinit {
        print("GOOGLE DRIVE VIEW MODEL IS DEALLOCATED")
    }
    
    func syncFiles() -> Promise<Void> {
        syncGoogleDriveFilesUseCase.sync(folderID: folderID)
    }
    
    func observeFiles() -> Observable<[GoogleDriveFileEntity]> {
        observeGoogleDriveFilesUseCase.observe(folderId: folderID)
            .observe(on: MainScheduler.instance)
    }
    
    func goToFolderVC(folderID: String, fileName: String) {
        self.navigationDelegate?.goToFolderVC(folderID: folderID, folderName: fileName)
    }
    
    func download(file: GoogleDriveFileEntity) -> Promise<Data> {
        self.downloadFileUseCase.download(file: file)
    }
    
    func uploadFile(with fileName: String, folderID: String, data: Data, mimeType: EGoogleDriveFileMimeType) -> (Promise<Void>, Observable<UploadProgressEntity>) {
        self.uploadFileUseCase.uploadFile(with: fileName, folderID: folderID, data: data, mimeType: mimeType)
    }
    
    func updateFileName(to newName: String, fileID: String) -> Promise<Void> {
        self.updateFileNameUseCase.updateFileName(to: newName, fileID: fileID)
    }
    
    func goToPreviewFileVC(file: GoogleDriveFileEntity) {
        self.navigationDelegate?.goToPreviewFileVC(file: file)
    }
    
    func goToPreviewImage(file: GoogleDriveFileEntity) {
        self.navigationDelegate?.goToPreviewImage(file: file)
    }
    
    func presentPickerOptions(viewController: GoogleDriveController) {
        self.presentationDelegate?.presentPickerOptions(viewController: viewController)
    }
    
    func presentImagePicker(viewController: GoogleDriveController) {
        self.presentationDelegate?.presentImagePicker(viewController: viewController)
    }
    
    func presentDocumentPicker(viewController: GoogleDriveController) {
        self.presentationDelegate?.presentDocumentPicker(viewController: viewController)
    }
    
    func presentMoreOptions(viewController: GoogleDriveController, file: GoogleDriveFileEntity) {
        self.presentationDelegate?.presentMoreOptions(viewController: viewController, file: file)
    }
    
    func presentManageAccessVC(file: GoogleDriveFileEntity, viewController: GoogleDriveController) {
        self.presentationDelegate?.presentManageAccessVC(file: file, viewController: viewController)
    }
    
    func moveToTrash(with fileName: String, fileID: String) {
        self.moveToTrashUseCase.moveToTrashFile(with: fileName, fileID: fileID).then { _ in
            print("FILE MOVED TO TRASH")
            self.syncFiles().then {
                print("Synced Files 🔄")
            }.catch { error in
                //show alert vc
            }
        }
    }
    
    func addToStarred(with fileID: String, starred: Bool) -> Promise<Void> {
        self.addToStarredUseCase.addToStarred(with: fileID, starred: starred)
    }
}

extension GoogleDriveViewModel {
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
