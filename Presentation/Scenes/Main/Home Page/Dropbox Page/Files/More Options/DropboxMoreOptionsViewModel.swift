//
//  DropboxMoreOptionsViewModel.swift
//  Presentation
//
//  Created by Murad on 23.09.22.
//

import Foundation
import Domain

protocol DropboxMoreOptionsDelegate: AnyObject {
    func didSelectedRename()
    func didSelectedDelete()
}

class DropboxMoreOptionsViewModel {
    
    weak var delegate: DropboxMoreOptionsDelegate?
    
    var file: DropboxFileEntity
    
    var pickerOptions: [Option] {
        get {
            return [
                Option(icon: Asset.icEdit.image, label: "Rename"),
                Option(icon: Asset.icDelete.image, label: "Remove")
            ]
        }
    }
    
    init(delegate: DropboxMoreOptionsDelegate, file: DropboxFileEntity) {
        self.delegate = delegate
        self.file = file
    }
    
    func selectedRenama() {
        delegate?.didSelectedRename()
    }
    
    func selectedDelete() {
        delegate?.didSelectedDelete()
    }
}
