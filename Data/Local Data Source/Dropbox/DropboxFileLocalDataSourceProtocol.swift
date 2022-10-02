//
//  DropboxFileLocalDataSourceProtocol.swift
//  Data
//
//  Created by Murad on 22.09.22.
//

import Foundation
import Promises
import RxSwift

public protocol DropboxFileLocalDataSourceProtocol {
    func save(info: DropboxInfoLocalDTO) -> Promise<Void>
    func observeInfo() -> Observable<DropboxInfoLocalDTO>
    func save(files: [DropboxFileRemoteDTO], folderPath: String) -> Promise<Void>
    func observe(folderPath: String) -> Observable<[DropboxFileLocalDTO]>
}
