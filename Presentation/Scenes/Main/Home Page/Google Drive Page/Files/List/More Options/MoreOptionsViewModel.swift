//
//  MoreOptionsViewModel.swift
//  Presentation
//
//  Created by Murad on 16.09.22.
//

import Foundation
import Domain

protocol MoreOptionsDelegate: AnyObject {
    func didSelectedRename()
    func didSelectedStar(starred: Bool)
    func didSelectedManageAccess()
    func didSelectedCopyLink()
    func didSelectedDelete()
}

class MoreOptionsViewModel {
    
    weak var delegate: MoreOptionsDelegate?
    
    var file: GoogleDriveFileEntity
    
    var pickerOptions: [Option] {
        get {
            return [
                Option(icon: Asset.Icons.icEdit.image, label: "Rename"),
                Option(icon: file.starred ? Asset.Icons.icStarFilled.image : Asset.Icons.icStarOutlined.image, label: file.starred ? "Remove from starred" : "Add to Starred"),
                Option(icon: Asset.Icons.icPersonAdd.image, label: "Manage Access"),
                Option(icon: Asset.Icons.icLink.image, label: "Copy Link"),
                Option(icon: Asset.Icons.icDelete.image, label: "Remove")
            ]
        }
    }
    
    init(delegate: MoreOptionsDelegate? = nil, file: GoogleDriveFileEntity) {
        self.delegate = delegate
        self.file = file
    }
    
    func selectedRenama() {
        delegate?.didSelectedRename()
    }
    
    func selectedStar(starred: Bool) {
        delegate?.didSelectedStar(starred: starred)
    }
    
    func selectedManageAccess() {
        if let delegate = delegate {
            delegate.didSelectedManageAccess()
        }
    }
    
    func selectedCopyLink() {
        delegate?.didSelectedCopyLink()
    }
    
    func selectedDelete() {
        delegate?.didSelectedDelete()
    }
}
