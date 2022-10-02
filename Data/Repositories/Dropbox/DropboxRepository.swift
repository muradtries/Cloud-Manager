//
//  DropboxRepository.swift
//  Data
//
//  Created by M/D Student - Murad A. on 21.09.22.
//

import Foundation
import SwiftyDropbox
import RxSwift
import Promises
import Domain

class DropboxRepo: DropboxRepoProtocol {

    private let remoteDataSource: DropboxFileRemoteDataSourceProtocol
    private let localDataSource: DropboxFileLocalDataSourceProtocol
    
    init(remoteDataSource: DropboxFileRemoteDataSourceProtocol,
         localDataSource: DropboxFileLocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        print("DROPBOX REPO IS INITIALIZED")
    }
    
    func syncDropboxInfo() -> Promise<Void> {
        let promise = Promise<Void>.pending()
        
        self.remoteDataSource.fetchDropboxInfo()
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
    
    func observeDropboxInfo() -> Observable<DropboxInfoEntity> {
        self.localDataSource.observeInfo().map { $0.toDomain }
    }
    
    func syncFiles(_ folderPath: String) -> Promise<Void> {
        let promise = Promise<Void>.pending()
        
        self.remoteDataSource.fetchFiles(in: folderPath)
            .then { fileList in
                return self.localDataSource.save(files: fileList, folderPath: folderPath)
            }
            .then { void in
                promise.fulfill(void)
            }
            .catch { error in
                promise.reject(error)
            }
        
        return promise
    }
    
    func observeFiles(folderPath: String) -> Observable<[DropboxFileEntity]> {
        self.localDataSource.observe(folderPath: folderPath).map { localDTOs in
            localDTOs.map { $0.toDomain }
        }
    }
    
    func downloadFile(in folderPath: String, file: DropboxFileEntity) -> Promises.Promise<Data> {
        self.remoteDataSource.downloadFile(in: folderPath, file: file.toRemote)
    }
    
    func uploadFile(to folderPath: String, with fileName: String, data: Data) -> (Promise<Void>, Observable<UploadProgressEntity>) {
        let (promise, observable) = self.remoteDataSource.uploadFile(to: folderPath, with: fileName, data: data)
        return (promise, observable.map{ $0.toDomain })
    }
    
    func updateFileName(from previousName: String, to newName: String, parentFolderPath: String) -> Promises.Promise<Void> {
        self.remoteDataSource.updateFileName(from: previousName, to: newName, parentFolderPath: parentFolderPath)
    }
    
    func moveToTrashFile(path: String) -> Promise<Void> {
        self.remoteDataSource.moveToTrashFile(path: path)
    }
    
    deinit {
        print("DROPBOX REPO DEALLOCATED")
    }
}
