//
//  Coordinator.swift
//  Presentation
//
//  Created by Murad on 30.08.22.
//

import UIKit

public protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get }
    var children: [Coordinator] { get set }
    
    func start()
}
