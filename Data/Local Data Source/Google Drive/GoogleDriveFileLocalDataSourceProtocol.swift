//
//  GoogleDriveFileLocalDataSourceProtocol.swift
//  Data
//
//  Created by Murad on 01.09.22.
//

import Foundation
import Promises
import RxSwift

public protocol GoogleDriveFileLocalDataSourceProtocol {
    func save(info: GoogleDriveInfoLocalDTO) -> Promise<Void>
    func observeInfo() -> Observable<GoogleDriveInfoLocalDTO>
    func save(files: [GoogleDriveFileLocalDTO], folderID: String) -> Promise<Void>
    func observe(folderID: String) -> Observable<[GoogleDriveFileLocalDTO]>
}
