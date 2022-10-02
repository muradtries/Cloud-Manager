//
//  EDropboxFileMimeType.swift
//  Domain
//
//  Created by Murad on 22.09.22.
//

import Foundation

public enum EDropboxFileMimeType {
    case folder
    case pdf(String)
    case document(String)
    case spreadSheet(String)
    case image(String)
    case video(String)
    
    public var toFileExtension: String {
        switch self {
        case .folder:
            return ""
        case .pdf(let type):
            return type
        case .document(let type):
            return type
        case .spreadSheet(let type):
            return type
        case .image(let type):
            return type
        case .video(let type):
            return type
        }
    }
    
    public var toString: String {
        switch self {
        case .folder:
            return "folder"
        case .pdf:
            return "pdf"
        case .document(let type):
            return type
        case .spreadSheet:
            return "xlsx"
        case .image(let type):
            return type
        case .video(let type):
            return type
        }
    }
}
