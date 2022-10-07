//
//  DropboxFileRemoteDataSource.swift
//  Data
//
//  Created by Murad on 22.09.22.
//

import Foundation
import RxSwift
import RxRelay
import SwiftyDropbox
import Promises

class DropboxFileRemoteDataSource: DropboxFileRemoteDataSourceProtocol {
    
    var authorizedClient: DropboxClient?
    
    private lazy var uploadRelay: PublishRelay<UploadProgressRemoteDTO> = .init()
    
    init() {
        if let client = DropboxClientsManager.authorizedClient {
            authorizedClient = client
        }
        
        print("DROPBOX REMOTE DATA SOURCE IS INITIALIZED")
    }
    
    func fetchDropboxInfo() -> Promise<DropboxInfoRemoteDTO> {
        let promise = Promise<DropboxInfoRemoteDTO>.pending()
        
        all(on: DispatchQueue.global(), fetchAccountInfo(), fetchStorageUsage()).then { account, storageUsage in
            let info = DropboxInfoRemoteDTO(ownerDisplayName: account.name.displayName,
                                         profilePhotoLink: account.profilePhotoUrl ?? "null",
                                         ownerEmailAdress: account.email,
                                         storageLimit: "2147483648",
                                         storageUsage: storageUsage.used.description)
            promise.fulfill(info)
        }
        
        return promise
    }
    
    func fetchFiles(in folderPath: String) -> Promise<[DropboxFileRemoteDTO]> {
        let promise = Promise<[DropboxFileRemoteDTO]>.pending()
        
        if let client = DropboxClientsManager.authorizedClient {
            
            var fileList: [DropboxFileRemoteDTO] = []
                .sorted(by: { lhs, rhs in
                lhs.name < rhs.name
            })
            
            client.files.listFolder(path: folderPath, recursive: false, includeMediaInfo: true, includeDeleted: false, includeHasExplicitSharedMembers: true, includeMountedFolders: true, limit: 30).response { result, error in
                
                if let listing = result {
                    for entry in listing.entries {
                        switch entry {
                        case let fileMetadata as Files.FileMetadata:
                            let dto = DropboxFileRemoteDTO(identifier: String(fileMetadata.id.removeIDPrefix),
                                                           name: fileMetadata.name,
                                                           lastModified: fileMetadata.clientModified,
                                                           path: fileMetadata.pathLower ?? "",
                                                           mimeType: fileMetadata.name.pathExtension)
                            fileList.append(dto)
                        case let folderMetadata as Files.FolderMetadata:
                            let dto = DropboxFileRemoteDTO(identifier: String(folderMetadata.id.removeIDPrefix),
                                                           name: folderMetadata.name,
                                                           lastModified: Date(),
                                                           path: folderMetadata.pathLower ?? "",
                                                           mimeType: "folder")
                            fileList.append(dto)
                        default:
                            print("other")
                        }
                    }
                    
                    promise.fulfill(fileList)
                }
            }
        } else {
            promise.reject(NSError(domain: "syncFiles", code: 1))
        }
        
        return promise
    }
    
    func downloadFile(in folderPath: String, file: DropboxFileRemoteDTO) -> Promise<Data> {
        let promise = Promise<Data>.pending()
        
        if let client = self.authorizedClient {
            client.files.download(path: folderPath)
                .response(queue: DispatchQueue.global()) { response, error in
                    if let response = response {
                        print(String(describing: response))
                        do {
                            try self.writeToDisk(data: response.1, fileName: file.identifier, mimeType: file.mimeType)
                        } catch {
                            print("ERROR OCCURED WHILE WRITING TO DISK \(error.localizedDescription)")
                        }
                        promise.fulfill(response.1)
                    }
                }
                .progress { progress in
                    print(progress)
                }
        }
        
        return promise
    }
    
    func uploadFile(to folderPath: String, with fileName: String, data: Data) -> (Promise<Void>, Observable<UploadProgressRemoteDTO>) {
        let promise = Promise<Void>.pending()
        
        if let client = self.authorizedClient {
            client.files.upload(path: "\(folderPath)/\(fileName)", mode: .add, autorename: true, mute: false, strictConflict: false,input: data)
            .response(queue: DispatchQueue.global()) { fileMetadata, error in
                guard error == nil else {
                    promise.reject(error as! any Error)
                    print("OH, AN ERROR OCCURED WHILE UPLOADING FILE TO DRIVE")
                    return
                }
                
                promise.fulfill(Void())
            }
            .progress { progress in
                self.uploadRelay.accept(UploadProgressRemoteDTO(id: "\(UUID())-\(fileName)", progress: progress))
            }
        }
        
        return (promise, self.uploadRelay.asObservable())
    }
    
    func updateFileName(from previousName: String, to newName: String, parentFolderPath: String) -> Promises.Promise<Void> {
        let promise = Promise<Void>.pending()
        
        if let client = self.authorizedClient {
            client.files.moveV2(fromPath: "\(parentFolderPath)/\(previousName)", toPath: "\(parentFolderPath)/\(newName)")
                .response(queue: DispatchQueue.global()) { result, error in
                    print(String(describing: result))
                    promise.fulfill(Void())
                }
        }
        
        return promise
    }
    
    func moveToTrashFile(path: String) -> Promise<Void> {
        let promise = Promise<Void>.pending()
        
        if let client = self.authorizedClient {
            client.files.deleteV2(path: path)
                .response(queue: DispatchQueue.global()) { result, error in
                    print(String(describing: result))
                    promise.fulfill(Void())
                }
        }
        
        return promise
    }
    
    deinit {
        print("DROPBOX REMOTE DATA SOURCE IS DEALLOCATED")
    }
}

extension DropboxFileRemoteDataSource {
    private func fetchAccountInfo() -> Promise<Users.FullAccount> {
        let promise = Promise<Users.FullAccount>.pending()
        
        if let client = authorizedClient {
            let _ = client.users.getCurrentAccount().response(queue: DispatchQueue.global()) { account, error in
                guard account != nil,error == nil else {
                    return promise.reject(NSError(domain: "getCurrentAccount", code: 1))
                }
                
                if let account = account {
                    promise.fulfill(account)
                }
            }
        } else {
            promise.reject(NSError(domain: "fetchAccountInfo", code: 1))
        }
        
        return promise
    }
    
    private func fetchStorageUsage() -> Promise<Users.SpaceUsage> {
        let promise = Promise<Users.SpaceUsage>.pending()
        
        if let client = authorizedClient {
            let _ = client.users.getSpaceUsage().response(queue: DispatchQueue.global()) { spaceUsage, error in
                guard spaceUsage != nil, error == nil else {
                    return promise.reject(NSError(domain: "getSpaceUsage", code: 1))
                }
                
                if let spaceUsage = spaceUsage {
                    promise.fulfill(spaceUsage)
                }
            }
        }
        
        return promise
    }
    
    private func writeToDisk(data: Data, fileName: String, mimeType: String) throws {
        
        let fileNameWithoutExtension = (fileName as NSString).deletingPathExtension
        
        print("FILE NAME: \(fileNameWithoutExtension) FILE MIME TYPE: \(mimeType)")
        
        let manager = FileManager.default
        
        let documentsURL: URL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        print("DOCUMENTS SUBDIR-S \(try! documentsURL.subDirectories())")
        
        let downloadedDocumentsURL: URL = documentsURL.appendingPathComponent(".downloaded_files")
        
        if !manager.fileExists(atPath: downloadedDocumentsURL.relativePath) {
            try manager.createDirectory(at: downloadedDocumentsURL,
                                        withIntermediateDirectories: false,
                                        attributes: nil
            )
        }
        
        print("DOCUMENTS SUBDIR-S \(try! documentsURL.subDirectories())")
        
        let fileURL = downloadedDocumentsURL.appendingPathComponent("\(fileNameWithoutExtension)\(mimeType)")
        try data.write(to: fileURL)
        
        print("SUBDIRECTORIES INSISDE DOWNLOADED DOCUMENTS: \(try downloadedDocumentsURL.getFiles())")
        print("DATA WRITTEN TO DISK")
    }
}

extension DropboxFileRemoteDataSource {
    func extractFileExtension(from string: String) -> String {
        let string = string as NSString
        return string.pathExtension
    }
}
