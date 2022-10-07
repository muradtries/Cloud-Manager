//
//  DataAssembly.swift
//  Data
//
//  Created by Murad on 28.08.22.
//

import Foundation
import Swinject
import Domain
import Realm
import RealmSwift
import GoogleSignIn
import GoogleAPIClientForREST_Drive

public class DataAssembly: Assembly {
    
    public init() {
        print("DATA ASSEMBLY IS INITIALIZED")
    }
    
    deinit {
        print("DATA ASSEMBLY IS DEALLOCATED")
    }
    
    public func assemble(container: Container) {
        
        container.register(GTLRDriveService.self) { r in
            print("CURRENT USER: \(String(describing: GIDSignIn.sharedInstance.currentUser))")
            return GTLRDriveService()
        }
        
        container.register(Realm.self) { r in
            try! Realm(
                configuration: Realm.Configuration(schemaVersion: 7, deleteRealmIfMigrationNeeded: true)
            )
        }.inObjectScope(.container)
        
        container.register(GoogleDriveFileRemoteDataSourceProtocol.self) { r in
            GoogleDriveFileRemoteDataSource(service: r.resolve(GTLRDriveService.self)!)
        }
        
        container.register(DropboxFileRemoteDataSourceProtocol.self) { r in
            DropboxFileRemoteDataSource()
        }
        
        container.register(GoogleDriveFileLocalDataSourceProtocol.self) { r in
            GoogleDriveFileLocalDataSource(defaultRealm: r.resolve(Realm.self)!)
        }.inObjectScope(.container)
        
        container.register(DropboxFileLocalDataSourceProtocol.self) { r in
            DropboxFileLocalDataSource(defaultRealm: r.resolve(Realm.self)!)
        }.inObjectScope(.container)
        
        container.register(GoogleDriveRepoProtocol.self) { r in
            GoogleDriveRepo(remoteDataSource: r.resolve(GoogleDriveFileRemoteDataSourceProtocol.self)!,
                            localDataSource: r.resolve(GoogleDriveFileLocalDataSourceProtocol.self)!)
        }
        
        container.register(DropboxRepoProtocol.self) { r in
            DropboxRepo(remoteDataSource: r.resolve(DropboxFileRemoteDataSourceProtocol.self)!,
                        localDataSource: r.resolve(DropboxFileLocalDataSourceProtocol.self)!)
        }
        
        container.register(ConnectGoogleDriveRepoProtocol.self) { r in
            ConnectGoogleDriveRepo()
        }
        
        container.register(ConnectDropboxRepoProtocol.self) { r in
            ConnectDropboxRepo()
        }
        
        container.register(GoogleDrivePermissionRepoProtocol.self) { r in
            GoogleDriveRepo(remoteDataSource: r.resolve(GoogleDriveFileRemoteDataSourceProtocol.self)!,
                            localDataSource: r.resolve(GoogleDriveFileLocalDataSourceProtocol.self)!)
        }
    }
}
