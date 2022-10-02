//
//  GoogleDriveFileLocalDataSource.swift
//  Data
//
//  Created by Murad on 01.09.22.
//

import Foundation
import RxSwift
import RxRelay
import Promises
import Realm
import RealmSwift

class GoogleDriveFileLocalDataSource: GoogleDriveFileLocalDataSourceProtocol {
    
    private let defaultRealm: Realm
    
    private lazy var infoRelay: BehaviorRelay<GoogleDriveInfoLocalDTO> = .init(value: GoogleDriveInfoLocalDTO())
    private lazy var filesRelay: BehaviorRelay<[GoogleDriveFileLocalDTO]> = .init(value: [])
    
    init(defaultRealm: Realm) {
        self.defaultRealm = defaultRealm
        print("GOOGLE DRIVE LOCAL DATA SOURCE IS INITIALIZED")
    }
    
    func save(info: GoogleDriveInfoLocalDTO) -> Promise<Void> {
        let promise = Promise<Void>.pending()
        
        let oldObjs = self.defaultRealm.objects(GoogleDriveInfoLocalDTO.self)
        
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
    
    func observeInfo() -> Observable<GoogleDriveInfoLocalDTO> {
        let cache = (self.defaultRealm.objects(GoogleDriveInfoLocalDTO.self).first ?? GoogleDriveInfoLocalDTO()) as GoogleDriveInfoLocalDTO
        self.infoRelay.accept(cache)
        return self.infoRelay.asObservable()
    }
    
    func save(files: [GoogleDriveFileRemoteDTO], folderId: String) -> Promise<Void> {
        let promise = Promise<Void>.pending()
        
        print("Remote count: \(files.count)")

        let oldObjs = self.defaultRealm.objects(GoogleDriveFileLocalDTO.self)
            .filter { localDTO in
                localDTO.folderId == folderId
            }
        do {
            try defaultRealm.write {
                defaultRealm.delete(oldObjs)
            }
            
            let localDTOs = files.map { remoteDTO -> GoogleDriveFileLocalDTO in
                let fileObj = GoogleDriveFileLocalDTO()
                fileObj.folderId = folderId
                fileObj.name = remoteDTO.name
                fileObj.identifier = remoteDTO.identifier
                fileObj.mimeType = remoteDTO.mimeType
                fileObj.trashed = remoteDTO.trashed
                fileObj.starred = remoteDTO.starred
                fileObj.shared = remoteDTO.shared
                fileObj.webContentLink = remoteDTO.webContentLink
                fileObj.permission = GoogleDrivePermissionLocalDTO.init(type: remoteDTO.permission.type, role: remoteDTO.permission.role)
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
    
    private func getFiles(in folderID: String) -> [GoogleDriveFileLocalDTO] {
        let predicate = NSPredicate(format: "folderId == %@", folderID)
        
        return self.defaultRealm.objects(GoogleDriveFileLocalDTO.self)
            .filter(predicate)
            .sorted(byKeyPath: "name", ascending: true)
            .freeze()
            .map { $0 }
    }
    
    func observe(folderId: String) -> Observable<[GoogleDriveFileLocalDTO]> {
//        if folderId == "root" {
//            self.filesRelay.accept(self.getFiles(in: "0ANN0ufbSoPkRUk9PVA"))
//            print("OBSERVING FOLDER ID: \(folderId)")
//            print("OBSERVING FOLDER ID CONTENT: \(self.getFiles(in: folderId))")
//        } else {
//            self.filesRelay.accept(self.getFiles(in: folderId))
//            print("OBSERVING FOLDER ID: \(folderId)")
//            print("OBSERVING FOLDER ID CONTENT: \(self.getFiles(in: folderId))")
//        }
        self.filesRelay.accept(self.getFiles(in: folderId))
        print("OBSERVING FOLDER ID: \(folderId)")
        print("OBSERVING FOLDER ID CONTENT: \(self.getFiles(in: folderId))")
        return self.filesRelay.asObservable()
    }
    
    deinit {
        print("GOOGLE DRIVE LOCAL DATA SOURCE IS DEALLOCATED")
    }
}
