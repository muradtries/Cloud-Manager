//
//  GoogleDriveRepoMockData.swift
//  DomainTests
//
//  Created by Murad on 29.09.22.
//

import Foundation
import Domain
import Promises
import RxSwift
import RxRelay

class GoogleDriveRepoMockData: GoogleDriveRepoProtocol {
    
    var observeInfoObservable = PublishRelay<GoogleDriveInfoEntity>.init()
    var syncInfoPromise = Promise<Void>.pending()
    
    var observeFileObservable = PublishRelay<[GoogleDriveFileEntity]>.init()
    var syncFilesPromise = Promise<Void>.pending()
    
    var restoreUserPromise = Promise<Void>.pending()
    
    var downloadFilePromise = Promise<Data>.pending()
    var (uploadFilePromise, observeProgressObservable) = (Promise<Void>.pending(), PublishRelay<UploadProgressEntity>.init())
    var moveToTrashFilePromise = Promise<Void>.pending()
    var updateFileNamePromise = Promise<Void>.pending()
    var addToStarredPromise = Promise<Void>.pending()
    
    func observeGoogleDriveInfo() -> Observable<GoogleDriveInfoEntity> {
        self.observeInfoObservable.asObservable()
    }
    
    func syncGoogleDriveInfo() -> Promise<Void> {
        self.syncInfoPromise
    }
    
    func observeFiles(folderId: String) -> Observable<[GoogleDriveFileEntity]> {
        self.observeFileObservable.asObservable()
    }
    
    func syncFiles(_ folderID: String) -> Promise<Void> {
        self.syncFilesPromise
    }
    
    func restoreUser() -> Promise<Void> {
        self.restoreUserPromise
    }
    
    func download(file: GoogleDriveFileEntity) -> Promise<Data> {
        self.downloadFilePromise
    }
    
    func uploadFile(with fileName: String, folderID: String, data: Data, mimeType: EGoogleDriveFileMimeType) -> (Promise<Void>, RxSwift.Observable<UploadProgressEntity>) {
        (self.uploadFilePromise, self.observeProgressObservable.asObservable())
    }
    
    func moveToTrashFile(with fileName: String, fileID: String) -> Promise<Void> {
        self.moveToTrashFilePromise
    }
    
    func updateFileName(to newName: String, fileID: String) -> Promise<Void> {
        self.updateFileNamePromise
    }
    
    func addToStarred(fileID: String, starred: Bool) -> Promise<Void> {
        self.addToStarredPromise
    }
}
