//
//  GoogleDriveFileRemoteDataSource.swift
//  Data
//
//  Created by Murad on 01.09.22.
//

import Foundation
import RxSwift
import RxRelay
import Promises
import GoogleSignIn
import GoogleAPIClientForREST_Drive

enum Placeholder: String {
    case notFound = "Not Found"
    case null = "Null"
}

class GoogleDriveFileRemoteDataSource: GoogleDriveFileRemoteDataSourceProtocol {

    private let service: GTLRDriveService
    
    private lazy var uploadRelay: PublishRelay<UploadProgressRemoteDTO> = .init()
    
    init(service: GTLRDriveService) {
        self.service = service
        self.service.authorizer = GIDSignIn.sharedInstance.currentUser?.authentication.fetcherAuthorizer()
        print("GOOGLE DRIVE REMOTE DATA SOURCE IS INITIALIZED")
    }
    
    func restoreUser() -> Promise<Void> {
        let promise: Promise<Void> = .pending()
        
        let restore: Promise<GIDGoogleUser> = .pending()
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            print("USER IS HERE: \(String(describing: user?.profile?.email))")
            if let user = user {
                restore.fulfill(user)
            } else if let error = error {
                restore.reject(error)
            } else {
                restore.reject(NSError(domain: "restorePreviousSignIn", code: 1))
            }
        }
        
        
        restore.then { user in
            user.authentication.do { authentication, error in
                if let authentication = authentication {
                    self.service.authorizer = authentication.fetcherAuthorizer()
                    promise.fulfill(Void())
                } else if let error = error {
                    promise.reject(error)
                } else {
                    promise.reject(NSError(domain: "authentication", code: 2))
                }
            }
        }.catch { error in
            promise.reject(error)
        }
        
        return promise
    }
    
    func fetchGoogleDriveInfo() -> Promise<GoogleDriveInfoRemoteDTO> {
        let promise = Promise<GoogleDriveInfoRemoteDTO>.pending()
        let query = GTLRDriveQuery_AboutGet.query()
        query.fields = "user, storageQuota"
        
        self.restoreUser().then { _ in
            self.service.executeQuery(query) { ticket, result, error in
                guard error == nil else {
                    promise.reject(error!)
                    return
                }
                
                guard let result = result as? GTLRDrive_About else {
                    promise.reject(error!)
                    return
                }
                
                let remoteDTO = GoogleDriveInfoRemoteDTO(
                    ownerDisplayName: result.user?.displayName ?? Placeholder.notFound.rawValue,
                    profilePhotoLink: result.user?.photoLink ?? Placeholder.notFound.rawValue,
                    ownerEmailAdress: result.user?.emailAddress ?? Placeholder.notFound.rawValue,
                    storageLimit: result.storageQuota?.limit?.stringValue ?? Placeholder.null.rawValue,
                    storageUsage: result.storageQuota?.usage?.stringValue ?? Placeholder.null.rawValue,
                    storageUsageInDrive: result.storageQuota?.usageInDrive?.stringValue ?? Placeholder.null.rawValue,
                    storageUsageInTrash: result.storageQuota?.usageInDriveTrash?.stringValue ?? Placeholder.null.rawValue
                )

                promise.fulfill(remoteDTO)
            }
        }.catch { error in
            promise.reject(NSError(domain: "syncGoogleDriveInfo", code: 1))
        }
        
        return promise
    }
    
    func fetchFiles(in folderID: String) -> Promise<[GoogleDriveFileRemoteDTO]> {
        let promise = Promise<[GoogleDriveFileRemoteDTO]>.pending()
        
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 100
        query.q = "'\(folderID)' in parents and trashed = false"
        query.fields = "files(id,name,parents, mimeType, trashed, starred, shared, permissions, modifiedTime, webViewLink)"
        query.orderBy = "name"
        
        self.restoreUser().then { _ in
            self.service.executeQuery(query) { (ticket, result, error) in
                guard let result = result as? GTLRDrive_FileList else {
                    promise.reject(NSError(domain: "fetchFiles", code: 1))
                    return
                }
                
                let files = result.files.map { $0 }
                
                guard let files = files else {
                    promise.reject(NSError(domain: "filesConversion", code: 1))
                    return
                }
                
                var fileList: [GoogleDriveFileRemoteDTO] = []
                
                for file in files {
                    var permissionRole = ""
                    var permissionType = ""
                    let permissionsList = file.permissions!.filter { permission in
                        permission.type == "anyone"
                    }
                    
                    if permissionsList.isEmpty {
                        let _ = file.permissions?.filter { permission in
                            permission.role == "owner" && permission.type == "user"
                        }.map { permission in
                            permissionType = permission.type ?? "user"
                            permissionRole = permission.role ?? "owner"
                        }
                    } else {
                        permissionType = file.permissions?.first?.type ?? ""
                        permissionRole = file.permissions?.first?.role ?? ""
                    }
                    
                    let fileDTO = GoogleDriveFileRemoteDTO(identifier: file.identifier!,
                                                           name: file.name!,
                                                           mimeType: file.mimeType!,
                                                           trashed: file.trashed!.boolValue,
                                                           starred: file.starred!.boolValue,
                                                           shared: file.shared!.boolValue,
                                                           webContentLink: file.webViewLink!,
                                                           permission: GoogleDrivePermissionRemoteDTO(type: permissionType, role: permissionRole),
                                                           lastModified: file.modifiedTime!.date)
                    fileList.append(fileDTO)
                }
                
                promise.fulfill(fileList)
            }
        }.catch { error in
            promise.reject(NSError(domain: "syncGoogleDriveFiles", code: 1))
        }
        
        return promise
    }
    
    func download(file: GoogleDriveFileRemoteDTO) -> Promise<Data> {
        let promise = Promise<Data>.pending()
        
        print("FILE MIME TYPE: \(file.mimeType)")
        
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: file.identifier)
        self.service.executeQuery(query) { ticket, result, error in
            let result = result as? GTLRDataObject
            let data = result?.data
            print("DATA: \(String(describing: data))")
            do {
                try self.writeToDisk(data: data ?? Data(), fileName: file.identifier, mimeType: file.mimeType)
            } catch {
                print("ERROR OCCURED WHILE WRITING TO DISK \(error.localizedDescription)")
            }
            
            promise.fulfill(data ?? Data())
        }
        
        return promise
    }
    
    func uploadFile(with fileName: String, folderID: String, data: Data, mimeType: String) -> (Promise<Void>, Observable<UploadProgressRemoteDTO>) {
        let promise = Promise<Void>.pending()
        
        let file = GTLRDrive_File()
        file.name = fileName
        file.parents = [folderID]
        
        let uploadParameters = GTLRUploadParameters(data: data, mimeType: mimeType)
        
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
        
        self.service.uploadProgressBlock = { _, totalBytesUpload, totalBytesExpectedToUpload in
            print("\(totalBytesUpload) of \(totalBytesExpectedToUpload) is uploaded")
            let progress = Progress(totalUnitCount: Int64(totalBytesExpectedToUpload))
            progress.completedUnitCount = Int64(totalBytesUpload)
            
            self.uploadRelay.accept(UploadProgressRemoteDTO(id: "\(UUID())-\(fileName)", progress: progress))
        }
        
        self.service.executeQuery(query) { ticket, result, error in
            guard error == nil else {
                promise.reject(error!)
                print("OH, AN ERROR OCCURED WHILE UPLOADING FILE TO DRIVE")
                return
            }
            
            promise.fulfill(Void())
        }
        
        
        return (promise, self.uploadRelay.asObservable())
    }
    
    func updateFileName(to newName: String, fileID: String) -> Promise<Void> {
        return transformFile(with: newName, fileID: fileID) { file in
            file.name = newName
        }
    }
    
    func updateAccessToFile(with fileID: String, permissionRole: String) -> Promises.Promise<Void> {
        let promise = Promise<Void>.pending()
        
        let permission = GTLRDrive_Permission()
        permission.type = "anyone"
        permission.role = permissionRole
        
        let createQuery = GTLRDriveQuery_PermissionsCreate.query(withObject: permission, fileId: fileID)
        
        self.service.executeQuery(createQuery) { ticket, result, error in
            guard error == nil else {
                promise.reject(error!)
                print(error!.localizedDescription)
                print("OH, AN ERROR OCCURED WHILE UPDATING FILE PERMISSIONS")
                return
            }
            
            promise.fulfill(Void())
        }
        
        return promise
    }
    
    func addToStarred(with fileID: String, starred: Bool) -> Promise<Void> {
        return transformFile(with: "", fileID: fileID) { item in
            item.starred = starred as NSNumber
        }
    }
    
    func removeAccessToFile(with fileID: String) -> Promises.Promise<Void> {
        let promise = Promise<Void>.pending()
        
        let query = GTLRDriveQuery_PermissionsDelete.query(withFileId: fileID, permissionId: "anyoneWithLink")
        
        self.service.executeQuery(query) { ticket, result, error in
            guard error == nil else {
                promise.reject(error!)
                print(error!.localizedDescription)
                print("OH, AN ERROR OCCURED WHILE REMOVING FILE PERMISSION")
                return
            }
            
            promise.fulfill(Void())
        }
        
        return promise
    }
    
    func moveToTrashFile(with fileName: String, fileID: String) -> Promise<Void> {
        return transformFile(with: fileName, fileID: fileID) { item in
            item.trashed = true
        }
    }
    
    func transformFile(with fileName: String, fileID: String, block: (GTLRDrive_File) -> Void) -> Promise<Void> {
        let promise = Promise<Void>.pending()
        
        let file = GTLRDrive_File()
        block(file)
        
        let query = GTLRDriveQuery_FilesUpdate.query(withObject: file, fileId: fileID, uploadParameters: nil)
        
        self.service.executeQuery(query) { ticket, result, error in
            guard error == nil else {
                promise.reject(error!)
                print(error!.localizedDescription)
                print("OH, AN ERROR OCCURED WHILE TRANSFORMING FILE")
                return
            }
            
            promise.fulfill(Void())
        }
        
        return promise
    }
    
    private func writeToDisk(data: Data, fileName: String, mimeType: String) throws {
        
        let fileNameWithoutExtension = (fileName as NSString).deletingPathExtension
        
        print("FILE NAME: \(fileNameWithoutExtension) FILE MIME TYPE: \(mimeType)")
        
        let manager = FileManager.default
        
        let documentsURL: URL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        print("DOCUMENTS SUBDIR-S \(try documentsURL.subDirectories())")
        
        let downloadedDocumentsURL: URL = documentsURL.appendingPathComponent(".downloaded_files")
        
        if !manager.fileExists(atPath: downloadedDocumentsURL.relativePath) {
            try manager.createDirectory(at: downloadedDocumentsURL,
                                        withIntermediateDirectories: false,
                                        attributes: nil
            )
        }
        
        print("DOCUMENTS SUBDIR-S \(try documentsURL.subDirectories())")
        
        let fileURL = downloadedDocumentsURL.appendingPathComponent("\(fileNameWithoutExtension)\(mimeType)")
        try data.write(to: fileURL)
        
        print("SUBDIRECTORIES INSISDE DOWNLOADED DOCUMENTS: \(try downloadedDocumentsURL.getFiles())")
        print("DATA WRITTEN TO DISK")
    }
    
    deinit {
        print("GOOGLE DRIVE REMOTE DATA SOURCE IS DEALLOCATED")
    }
}
