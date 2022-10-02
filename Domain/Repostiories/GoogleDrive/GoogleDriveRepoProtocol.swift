//
//  GoogleDriveRepoProtocol.swift
//  Domain
//
//  Created by Murad on 28.08.22.
//

import Foundation
import RxSwift
import Promises

public protocol GoogleDriveRepoProtocol {
    func observeGoogleDriveInfo() -> Observable<GoogleDriveInfoEntity>
    func syncGoogleDriveInfo() -> Promise<Void>
    func observeFiles(folderId: String) -> Observable<[GoogleDriveFileEntity]>
    func syncFiles(_ folderID: String) -> Promise<Void>
    func restoreUser() -> Promise<Void>
    func download(file: GoogleDriveFileEntity) -> Promise<Data>
    func uploadFile(with fileName: String, folderID: String, data: Data, mimeType: EGoogleDriveFileMimeType) -> (Promise<Void>, Observable<UploadProgressEntity>)
    func moveToTrashFile(with fileName: String, fileID: String) -> Promise<Void>
    func updateFileName(to newName: String, fileID: String) -> Promise<Void>
    func addToStarred(fileID: String, starred: Bool) -> Promise<Void>
}
