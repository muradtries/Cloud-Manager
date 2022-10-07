//
//  DomainAssembly.swift
//  Domain
//
//  Created by Murad on 28.08.22.
//

import Foundation
import Swinject

public class DomainAssembly: Assembly {
    
    public init() {
        print("DOMAIN ASSEMBLY INITIALIZED")
    }
    
    deinit {
        print("DOMAIN ASSEMBLY DEALLOCATED")
    }
    
    public func assemble(container: Container) {
        
        container.register(ConnectGoogleDriveUseCase.self) { r in
            ConnectGoogleDriveUseCase(repo: r.resolve(ConnectGoogleDriveRepoProtocol.self)!)
        }
        
        container.register(ConnectDropboxUseCase.self) { r in
            ConnectDropboxUseCase(repo: r.resolve(ConnectDropboxRepoProtocol.self)!)
        }
        
        container.register(RestoreUserUseCase.self) { r in
            RestoreUserUseCase(repo: r.resolve(GoogleDriveRepoProtocol.self)!)
        }
        
        container.register(ObserveGoogleDriveInfoUseCase.self) { r in
            ObserveGoogleDriveInfoUseCase(repo: r.resolve(GoogleDriveRepoProtocol.self)!)
        }
        
        container.register(ObserveDropboxInfoUseCase.self) { r in
            ObserveDropboxInfoUseCase(repo: r.resolve(DropboxRepoProtocol.self)!)
        }
        
        container.register(SyncGoogleDriveInfoUseCase.self) { r in
            SyncGoogleDriveInfoUseCase(repo: r.resolve(GoogleDriveRepoProtocol.self)!)
        }
        
        container.register(SyncDropboxInfoUseCase.self) { r in
            SyncDropboxInfoUseCase(repo: r.resolve(DropboxRepoProtocol.self)!)
        }
        
        container.register(ObserveGoogleDriveFilesUseCase.self) { r in
            ObserveGoogleDriveFilesUseCase(repo: r.resolve(GoogleDriveRepoProtocol.self)!)
        }
        
        container.register(ObserveDropboxFilesUseCase.self) { r in
            ObserveDropboxFilesUseCase(repo: r.resolve(DropboxRepoProtocol.self)!)
        }
        
        container.register(SyncGoogleDriveFilesUseCase.self) { r in
            SyncGoogleDriveFilesUseCase(repo: r.resolve(GoogleDriveRepoProtocol.self)!)
        }
        
        container.register(SyncDropboxFilesUseCase.self) { r in
            SyncDropboxFilesUseCase(repo: r.resolve(DropboxRepoProtocol.self)!)
        }
        
        container.register(DownloadGoogleDriveFileUseCase.self) { r in
            DownloadGoogleDriveFileUseCase(repo: r.resolve(GoogleDriveRepoProtocol.self)!)
        }
        
        container.register(DownloadDropboxFileUseCase.self) { r in
            DownloadDropboxFileUseCase(repo: r.resolve(DropboxRepoProtocol.self)!)
        }
        
        container.register(UploadGoogleDriveFileUseCase.self) { r in
            UploadGoogleDriveFileUseCase(repo: r.resolve(GoogleDriveRepoProtocol.self)!)
        }
        
        container.register(UploadDropboxFileUseCase.self) { r in
            UploadDropboxFileUseCase(repo: r.resolve(DropboxRepoProtocol.self)!)
        }
        
        container.register(UpdateFileNameUseCase.self) { r in
            UpdateFileNameUseCase(repo: r.resolve(GoogleDriveRepoProtocol.self)!)
        }
        
        container.register(UpdateDropboxFileNameUseCase.self) { r in
            UpdateDropboxFileNameUseCase(repo: r.resolve(DropboxRepoProtocol.self)!)
        }
        
        container.register(AddToStarredUseCase.self) { r in
            AddToStarredUseCase(repo: r.resolve(GoogleDriveRepoProtocol.self)!)
        }
        
        container.register(MoveToTrashUseCase.self) { r in
            MoveToTrashUseCase(repo: r.resolve(GoogleDriveRepoProtocol.self)!)
        }
        
        container.register(MoveToTrashDropboxFileUseCase.self) { r in
            MoveToTrashDropboxFileUseCase(repo: r.resolve(DropboxRepoProtocol.self)!)
        }
        
        container.register(ManageAccessToFileUseCase.self) { r in
            ManageAccessToFileUseCase(repo: r.resolve(GoogleDrivePermissionRepoProtocol.self)!)
        }
        
        container.register(RemoveAccessToFileUseCase.self) { r in
            RemoveAccessToFileUseCase(repo: r.resolve(GoogleDrivePermissionRepoProtocol.self)!)
        }
    }
}
