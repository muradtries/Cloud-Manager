//
//  PickerOptionsViewModel.swift
//  Presentation
//
//  Created by Murad on 15.09.22.
//

import Foundation

protocol PickerOptionsDelegate: AnyObject {
    func didSelectFromPhotos()
    func didSelectFromDocuments()
}

class PickerOptionsViewModel {
    
    weak var delegate: PickerOptionsDelegate?
    
    var pickerOptions: [Option] {
        get {
            return [
                Option(icon: Asset.Icons.icPhotosLibrary.image, label: "Photos Library"),
                Option(icon: Asset.Icons.icFolder.image, label: "Documents")
            ]
        }
    }
    
    func selectedPhotos() {
        delegate?.didSelectFromPhotos()
    }
    
    func selectedDocuments() {
        delegate?.didSelectFromDocuments()
    }
}
