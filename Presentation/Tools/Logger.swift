//
//  Logger.swift
//  Presentation
//
//  Created by Murad on 25.09.22.
//

import Foundation

enum ViewType {
    case viewController
    case popup
}

enum State {
    case initialized
    case deallocated
}

struct Logger {
    
    static let shared = Logger.init()
    
    func logCoordinatorStarted(coordinatorName: String, state: State) {
        switch state {
        case .initialized:
            print("🚦 \(coordinatorName.uppercased()) COORDINATOR STARTED")
        case .deallocated:
            print("🗑 \(coordinatorName.uppercased()) COORDINATOR DEALLOCATED")
        }
    }
    
    func logViewControllerState(name: String, type: ViewType, state: State) {
        switch type {
        case .viewController:
            switch state {
            case .initialized:
                print("🏁 \(name.uppercased()) VC IS DEALLOCATED")
            case .deallocated:
                print("🗑 \(name.uppercased()) VC IS DEALLOCATED")
            }
        case .popup:
            print("🗑 \(name.uppercased()) POP UP IS DEALLOCATED")
        }
    }
    
    func logSynced() {
        print("🔄 Synced Files")
    }
    
    func logError(errorDescription: String) {
        print("😧 OH AN ERROR OCCURED. ERROR SAYS \(errorDescription)")
    }
}
