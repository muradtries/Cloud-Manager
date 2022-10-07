//
//  GoogleDriveRepository.swift
//  Data
//
//  Created by Murad on 28.08.22.
//

import Foundation
import Domain
import RxSwift
import RxRelay
import Promises
import GoogleSignIn
import GoogleAPIClientForREST_Drive

class GoogleDriveRepo: GoogleDriveRepoProtocol, GoogleDrivePermissionRepoProtocol {

    private let remoteDataSource: GoogleDriveFileRemoteDataSourceProtocol
    private let localDataSource: GoogleDriveFileLocalDataSourceProtocol
    
    init(remoteDataSource: GoogleDriveFileRemoteDataSourceProtocol,
         localDataSource: GoogleDriveFileLocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        print("GOOGLE DRIVE REPO IS INITIALIZED")
    }
    
    func restoreUser() -> Promise<Void> {
        self.remoteDataSource.restoreUser()
    }
    
    func observeGoogleDriveInfo() -> Observable<GoogleDriveInfoEntity> {
        self.localDataSource.observeInfo().map { $0.toDomain }
    }
    
    func syncGoogleDriveInfo() -> Promise<Void> {
        let promise = Promise<Void>.pending()
        
        self.remoteDataSource.fetchGoogleDriveInfo()
            .then { info in
                return self.localDataSource.save(info: info.toLocal)
            }
            .then { void in
                promise.fulfill(void)
            }
            .catch { error in
                promise.reject(error)
            }
        
        return promise
    }
    
    func syncFiles(_ folderID: String) -> Promise<Void> {
        let promise = Promise<Void>.pending()
        
        self.remoteDataSource.fetchFiles(in: folderID)
            .then { data in
                let localData = data.map { remote in
                    remote.toLocal(folderID: folderID)
                }
                return self.localDataSource.save(files: localData, folderID: folderID)
            }
            .then { void in
                promise.fulfill(void)
            }
            .catch { error in
                promise.reject(error)
            }
        
        return promise
    }
    
    func observeFiles(folderID: String) -> Observable<[GoogleDriveFileEntity]> {
        self.localDataSource.observe(folderID: folderID).map { localDTOs in
            localDTOs.map { $0.toDomain }
        }
    }
    
    func download(file: GoogleDriveFileEntity) -> Promise<Data> {
        self.remoteDataSource.download(file: file.toRemote)
    }
    
    func uploadFile(with fileName: String, folderID: String, data: Data, mimeType: EGoogleDriveFileMimeType) -> (Promise<Void>, Observable<UploadProgressEntity>) {
        let (promise, observable) = self.remoteDataSource.uploadFile(with: fileName, folderID: folderID, data: data, mimeType: mimeType.toString)
        return (promise, observable.map{ $0.toDomain })
    }
    
    func updateFileName(to newName: String, fileID: String) -> Promise<Void> {
        self.remoteDataSource.updateFileName(to: newName, fileID: fileID)
    }
    
    func addToStarred(fileID: String, starred: Bool) -> Promises.Promise<Void> {
        self.remoteDataSource.addToStarred(with: fileID, starred: starred)
    }
    
    func manageAccessToFile(with fileID: String, permissionRole: EPermissionRole) -> Promises.Promise<Void> {
        self.remoteDataSource.updateAccessToFile(with: fileID, permissionRole: permissionRole.toString())
    }
    
    func removeAccessToFile(with fileID: String) -> Promises.Promise<Void> {
        self.remoteDataSource.removeAccessToFile(with: fileID)
    }
    
    func moveToTrashFile(with fileName: String, fileID: String) -> Promise<Void> {
        self.remoteDataSource.moveToTrashFile(with: fileName, fileID: fileID)
    }
    
    deinit {
        print("GOOGLE DRIVE REPO IS DEALLOCATED")
    }
}
