//
//  ApplicationCoordinator.swift
//  Presentation
//
//  Created by Murad on 30.08.22.
//

import Foundation
import UIKit
import Swinject
import Domain

public class AppCoordinator: Coordinator {
    
    public var parentCoordinator: Coordinator?
    
    public var children: [Coordinator] = []
    
    private let resolver: Resolver
    
    public init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    public func start() {
        print("🚦 APP COORDINATOR STARTED")
        goToHome()
    }
    
    func goToHome() {
        let coordinator = resolver.resolve(HomeTabBarCoordinator.self)!
        coordinator.parentCoordinator = self
        children.append(coordinator)
        
        coordinator.start()
    }
    
    deinit {
        print("🗑 APP COORDINATOR DEALLOCATED")
    }
}
