//
//  EMimeType.swift
//  Domain
//
//  Created by Murad on 06.09.22.
//

import Foundation

public enum EGoogleDriveFileMimeType {
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
            return "application/vnd.google-apps.folder"
        case .pdf:
            return "application/pdf"
        case .document(let type):
            return "application/\(type)"
        case .spreadSheet:
            return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case .image(let string):
            return "image/\(string)"
        case .video(let string):
            return "video/\(string)"
        }
    }
}
