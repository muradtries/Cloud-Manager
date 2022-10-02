//
//  DropboxFileRemoteDataSourceProtocol.swift
//  Data
//
//  Created by Murad on 22.09.22.
//

import Foundation
import Domain
import RxSwift
import Promises

public protocol DropboxFileRemoteDataSourceProtocol {
    func fetchFiles(in folderID: String) -> Promise<[DropboxFileRemoteDTO]>
    func fetchDropboxInfo() -> Promise<DropboxInfoRemoteDTO>
    func downloadFile(in folderPath: String, file: DropboxFileRemoteDTO) -> Promise<Data>
    func uploadFile(to folderPath: String, with fileName: String, data: Data) -> (Promise<Void>, Observable<UploadProgressRemoteDTO>)
    func updateFileName(from previousName: String, to newName: String, parentFolderPath: String) -> Promises.Promise<Void>
    func moveToTrashFile(path: String) -> Promise<Void>
}
