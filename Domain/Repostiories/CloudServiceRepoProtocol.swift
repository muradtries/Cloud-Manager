//
//  CloudServiceRepoProtocol.swift
//  Domain
//
//  Created by Murad on 26.09.22.
//

import Foundation
import RxSwift
import Promises

public protocol CloudServiceRepoProtocol {
    associatedtype serviceEntity
    
    func observeGoogleDriveInfo() -> Observable<GoogleDriveInfoEntity>
    func syncGoogleDriveInfo() -> Promise<Void>
    func observeFiles(folderId: String) -> Observable<[serviceEntity]>
    func syncFiles(_ folderID: String) -> Promise<Void>
    func restoreUser() -> Promise<Void>
    func download(file: serviceEntity) -> Promise<Data>
    func uploadFile(with fileName: String, folderID: String, data: Data, mimeType: EGoogleDriveFileMimeType) -> Promise<Void>
    func moveToTrashFile(with fileName: String, fileID: String) -> Promise<Void>
    func updateFileName(to newName: String, fileID: String) -> Promise<Void>
    func addToStarred(fileID: String, starred: Bool) -> Promise<Void>
}
