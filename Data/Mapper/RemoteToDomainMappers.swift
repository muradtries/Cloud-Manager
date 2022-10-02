//
//  RemoteToDomainMappers.swift
//  Data
//
//  Created by M/D Student - Murad A. on 27.09.22.
//

import Foundation
import Domain

extension UploadProgressRemoteDTO {
    var toDomain: UploadProgressEntity {
        UploadProgressEntity(id: self.id,
                             progress: self.progress)
    }
}
