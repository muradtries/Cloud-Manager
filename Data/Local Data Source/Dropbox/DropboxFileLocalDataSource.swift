//
//  DropboxFileLocalDataSource.swift
//  Data
//
//  Created by Murad on 22.09.22.
//

import Foundation
import Promises
import RxSwift
import RxRelay
import Realm
import RealmSwift

class DropboxFileLocalDataSource: DropboxFileLocalDataSourceProtocol {
    
    private let defaultRealm: Realm
    
    private lazy var infoRelay: BehaviorRelay<DropboxInfoLocalDTO> = .init(value: DropboxInfoLocalDTO())
    private lazy var filesRelay: BehaviorRelay<[DropboxFileLocalDTO]> = .init(value: [])
    
    init(defaultRealm: Realm) {
        self.defaultRealm = defaultRealm
        print("GOOGLE DRIVE LOCAL DATA SOURCE IS INITIALIZED")
    }
    
    func save(info: DropboxInfoLocalDTO) -> Promise<Void> {
        let promise = Promise<Void>.pending()
        
        let oldObjs = self.defaultRealm.objects(DropboxInfoLocalDTO.self)
        
        do {
            try defaultRealm.write {
                defaultRealm.delete(oldObjs)
            }
            
            try defaultRealm.write {
                defaultRealm.add(info)
            }
            
            infoRelay.accept(info)
            promise.fulfill(Void())
        } catch {
            promise.reject(error)
        } 
        
        return promise
    }
    
    func observeInfo() -> Observable<DropboxInfoLocalDTO> {
        let cache = (self.defaultRealm.objects(DropboxInfoLocalDTO.self).first ?? DropboxInfoLocalDTO()) as DropboxInfoLocalDTO
        self.infoRelay.accept(cache)
        return self.infoRelay.asObservable()
    }
    
    func save(files: [DropboxFileRemoteDTO], folderPath: String) -> Promise<Void> {
        let promise = Promise<Void>.pending()
        
        print("Remote count: \(files.count)")

        let oldObjs = self.defaultRealm.objects(DropboxFileLocalDTO.self)
            .filter { localDTO in
                localDTO.parentFolderPath == folderPath
            }
        do { 
            try defaultRealm.write {
                defaultRealm.delete(oldObjs)
            }
            
            let localDTOs = files.map { remoteDTO -> DropboxFileLocalDTO in
                let fileObj = DropboxFileLocalDTO()
                fileObj.name = remoteDTO.name
                fileObj.identifier = remoteDTO.identifier
                fileObj.parentFolderPath = folderPath
                fileObj.path = remoteDTO.path
                fileObj.mimeType = remoteDTO.mimeType
                fileObj.lastModified = remoteDTO.lastModified
                return fileObj
            }
            
            try defaultRealm.write {
                defaultRealm.add(localDTOs, update: .modified)
            }
            self.filesRelay.accept(localDTOs)
            promise.fulfill(Void())
        } catch {
            promise.reject(error)
        }
        
        return promise
    }
    
    private func getFiles(in folderPath: String) -> [DropboxFileLocalDTO] {
        let predicate = NSPredicate(format: "parentFolderPath == %@", folderPath)
        
        return self.defaultRealm.objects(DropboxFileLocalDTO.self)
            .filter(predicate)
            .sorted(byKeyPath: "name", ascending: true)
            .freeze()
            .map { $0 }
    }
    
    func observe(folderPath: String) -> Observable<[DropboxFileLocalDTO]> {
        self.filesRelay.accept(self.getFiles(in: folderPath))
        print("OBSERVING FOLDER ID: \(folderPath)")
        print("OBSERVING FOLDER ID CONTENT: \(self.getFiles(in: folderPath))")
        return self.filesRelay.asObservable()
    }
    
    deinit {
        print("DROPBOX LOCAL DATA SOURCE IS DEALLOCATED")
    }
}
