//
//  GoogleDriveFileRemoteDataSourceProtocol.swift
//  Data
//
//  Created by Murad on 01.09.22.
//

import Foundation
import RxSwift
import Promises

public protocol GoogleDriveFileRemoteDataSourceProtocol {
    func restoreUser() -> Promise<Void>
    func fetchGoogleDriveInfo() -> Promise<GoogleDriveInfoRemoteDTO>
    func fetchFiles(in folderID: String) -> Promise<[GoogleDriveFileRemoteDTO]>
    func download(file: GoogleDriveFileRemoteDTO) -> Promise<Data>
    func uploadFile(with fileName: String, folderID: String, data: Data, mimeType: String) -> (Promise<Void>, Observable<UploadProgressRemoteDTO>)
    func updateFileName(to newName: String, fileID: String) -> Promise<Void>
    func updateAccessToFile(with fileID: String, permissionRole: String) -> Promises.Promise<Void>
    func addToStarred(with fileID: String, starred: Bool) -> Promise<Void>
    func removeAccessToFile(with fileID: String) -> Promises.Promise<Void>
    func moveToTrashFile(with fileName: String, fileID: String) -> Promise<Void>
}
