//
//  SettingsCoordinator.swift
//  Presentation
//
//  Created by Murad on 06.09.22.
//

import Foundation
import Domain
import UIKit
import Swinject
import SwiftUI

class SettingsPageCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    private var navigationController: UINavigationController
    
    private var resolver: Resolver
    
    init(navigationController: UINavigationController,
         resolver: Resolver) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.resolver = resolver
    }
    
    deinit {
        print("SETTINGS PAGE COORDINATOR DEALLOCATED")
    }
    
    func start() {
        initializeSettingsVC()
    }
    
    func initializeSettingsVC() {
        let settingsVC = SettingsController(vm: SettingsPageViewModel())
        
        settingsVC.navigationItem.hidesBackButton = true
        
        let tabBarItem = UITabBarItem(title: "Settings", image: Asset.Icons.icSettings.image, tag: 2)
        settingsVC.tabBarItem = tabBarItem
        
        self.navigationController.pushViewController(settingsVC, animated: true)
    }
}
