//
//  UploadProgressEntity.swift
//  Domain
//
//  Created by M/D Student - Murad A. on 27.09.22.
//

import Foundation

public struct UploadProgressEntity {
    public let id: String
    public var progress: Progress
    
    public init(id: String, progress: Progress) {
        self.id = id
        self.progress = progress
    }
}
