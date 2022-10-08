//
//  ManageAccessViewModel.swift
//  Presentation
//
//  Created by Murad on 19.09.22.
//

import Foundation
import Promises
import Domain

protocol ManageAccessPopUpControllerDelegate: AnyObject {
    func didFinishedManagingAccess()
}

class ManageAccessViewModel {
    
    weak var delegate: ManageAccessPopUpControllerDelegate?
    
    let manageAccessToFileUseCase: ManageAccessToFileUseCase
    let removeAccessToFileUseCase: RemoveAccessToFileUseCase
    
    var file: GoogleDriveFileEntity?
    lazy var copyToClipboard: () = {
        UIPasteboard.general.string = file?.webContentLink
    }()
    
    init(file: GoogleDriveFileEntity? = nil, manageAccessToFileUseCase: ManageAccessToFileUseCase, removeAccessToFileUseCase: RemoveAccessToFileUseCase) {
        self.file = file
        self.manageAccessToFileUseCase = manageAccessToFileUseCase
        self.removeAccessToFileUseCase = removeAccessToFileUseCase
    }
    
    func didCopiedLinkToClipBoard(viewController: UIViewController) {
        print("didCopiedLinkToClipBoard")
        let alert = TopPopUpAlert()
        alert.show(viewController: viewController)
    }
    
    func didFinishedEditingOptions(role: AccessOptions) -> Promise<Void> {
        switch role {
        case .restricted:
            return removeAccessToFileUseCase.removeAccessToFile(with: file!.identifier)
        case .anyoneWithLink(let accessRole):
            return manageAccessToFileUseCase.manageAccessToFile(with: file!.identifier, permissionRole: accessRole)
        }
    }
    
    deinit {
        print("SHARING OPTIONS POP UP VM DEALLOCATED")
    }
}
