//
//  ServiceMode.swift
//  Presentation
//
//  Created by Murad on 28.09.22.
//

import Foundation

enum ServiceState {
    case connected
    case disconnected
}

struct ServiceModel {
    let name: String
    let icon: UIImage
    let state: ServiceState
    
    init(name: String, icon: UIImage, state: ServiceState = .disconnected) {
        self.name = name
        self.icon = icon
        self.state = state
    }
}
