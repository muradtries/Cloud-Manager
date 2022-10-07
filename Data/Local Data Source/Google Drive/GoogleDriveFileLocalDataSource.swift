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
    private lazy var compositeDisposable = CompositeDisposable()
    
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
    
    func save(files: [GoogleDriveFileLocalDTO], folderID: String) -> Promise<Void> {
        let promise = Promise<Void>.pending()
        
        let predicate = NSPredicate(format: "folderID == %@", folderID)
        let cached = self.defaultRealm.objects(GoogleDriveFileLocalDTO.self)
            .filter(predicate)
        
        do {
            try self.defaultRealm.write {
                self.defaultRealm.delete(cached)
                self.defaultRealm.add(files, update: .modified)
            }
            
            self.syncFiles(in: folderID)
            promise.fulfill(Void())
        } catch {
            promise.reject(error)
        }
        
        return promise
    }
    
    func observe(folderID: String) -> Observable<[GoogleDriveFileLocalDTO]> {
        self.syncFiles(in: folderID)
        return self.filesRelay.asObservable()
    }
    
    private func getFiles(in folderID: String) -> [GoogleDriveFileLocalDTO] {
        let predicate = NSPredicate(format: "folderID == %@", folderID)
        
        return self.defaultRealm.objects(GoogleDriveFileLocalDTO.self)
            .filter(predicate)
            .freeze()
            .map { $0 }
    }
    
    private func syncFiles(in folderID: String) {
        self.filesRelay.accept(self.getFiles(in: folderID))
    }
    
    deinit {
        print("GOOGLE DRIVE LOCAL DATA SOURCE IS DEALLOCATED")
    }
}
