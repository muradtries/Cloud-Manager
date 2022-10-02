//
//  DropboxRepoProtocol.swift
//  Domain
//
//  Created by M/D Student - Murad A. on 21.09.22.
//

import Foundation
import RxSwift
import Promises

public protocol DropboxRepoProtocol {
    func observeDropboxInfo() -> Observable<DropboxInfoEntity>
    func syncDropboxInfo() -> Promise<Void>
    func syncFiles(_ folderPath: String) -> Promise<Void>
    func observeFiles(folderPath: String) -> Observable<[DropboxFileEntity]>
    func downloadFile(in folderPath: String, file: DropboxFileEntity) -> Promise<Data>
    func uploadFile(to folderPath: String, with fileName: String, data: Data) -> (Promise<Void>, Observable<UploadProgressEntity>)
    func updateFileName(from previousName: String, to newName: String, parentFolderPath: String) -> Promise<Void>
    func moveToTrashFile(path: String) -> Promise<Void>
}
