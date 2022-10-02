//
//  HomeTabBarCoordinator.swift
//  Presentation
//
//  Created by Murad on 31.08.22.
//

import Foundation
import UIKit
import Domain
import Swinject

class HomeTabBarCoordinator: Coordinator {
    
    let restoreUserUseCase: RestoreUserUseCase
    
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    private let tabBarController: UITabBarController
    private let homePageNavigationController: UINavigationController
    private let settingsPageNavigationController: UINavigationController
    
    private var resolver: Resolver
    
    init(resolver: Resolver,
         restoreUserUseCase: RestoreUserUseCase,
         tabBarController: UITabBarController,
         homePageNavigationController: UINavigationController,
         settingsPageNavigationController: UINavigationController
    ) {
        self.resolver = resolver
        self.tabBarController = tabBarController
        self.restoreUserUseCase = restoreUserUseCase
        self.homePageNavigationController = homePageNavigationController
        self.settingsPageNavigationController = settingsPageNavigationController
    }
    
    func start() {
        print("🚦 HOME TABBAR COORDINATOR STARTED")
        initializeHomeTabBar()
    }
    
    func initializeHomeTabBar() {
        
        let homeCoordinator = HomePageCoordinator(navigationController: homePageNavigationController,
                                                  resolver: self.resolver)
        homeCoordinator.parentCoordinator = self.parentCoordinator
        homeCoordinator.initializeHomeVC()
        self.children.append(homeCoordinator)
        
        let settingsCoordinator = SettingsPageCoordinator(navigationController: settingsPageNavigationController,
                                                          resolver: self.resolver)
        settingsCoordinator.parentCoordinator = self.parentCoordinator
        settingsCoordinator.initializeSettingsVC()
        self.children.append(settingsCoordinator)
        
        let vc1 = self.homePageNavigationController
        let vc2 = self.settingsPageNavigationController
        
        tabBarController.viewControllers = [vc1, vc2]
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: FontFamily.Poppins.medium.font(size: 10)], for: .normal)
    }
    
    deinit {
        print("😶‍🌫️ HOME TABBAR COORDINATOR DEALLOCATED")
    }
}
