//
//  PresentationAssembly.swift
//  Presentation
//
//  Created by Murad on 31.08.22.
//

import Swinject
import Domain
import UIKit

public class PresentationAssembly: Assembly {
    
    private let homePageNavigationController: UINavigationController
    private let settingsPageNavigationController: UINavigationController
    private let tabBarController: UITabBarController
    
    public init(homePageNavigationController: UINavigationController, settingsPageNavigationController: UINavigationController, tabBarController: UITabBarController) {
        self.homePageNavigationController = homePageNavigationController
        self.settingsPageNavigationController = settingsPageNavigationController
        self.tabBarController = tabBarController
    }
    
    public func assemble(container: Container) {
        
        container.register(HomeTabBarCoordinator.self) { r in
            HomeTabBarCoordinator(
                resolver: r,
                restoreUserUseCase: r.resolve(RestoreUserUseCase.self)!,
                tabBarController: self.tabBarController,
                homePageNavigationController: self.homePageNavigationController,
                settingsPageNavigationController: self.settingsPageNavigationController
            )
        }.inObjectScope(.container)
        
        container.register(HomePageCoordinator.self) { r in
            HomePageCoordinator(navigationController: self.homePageNavigationController,
                                resolver: r)
        }
        
        container.register(HomePageViewModel.self) { r in
            HomePageViewModel(
                delegate: r.resolve(HomePageCoordinator.self)!,
                connectGoogleDriveUseCase: r.resolve(ConnectGoogleDriveUseCase.self)!,
                connectDropboxUseCase: r.resolve(ConnectDropboxUseCase.self)!,
                restoreUserUseCase: r.resolve(RestoreUserUseCase.self)!,
                syncGoogleDriveInfoUseCase: r.resolve(SyncGoogleDriveInfoUseCase.self)!,
                syncDropboxInfoUseCase: r.resolve(SyncDropboxInfoUseCase.self)!,
                observeGoogleDriveInfoUseCase: r.resolve(ObserveGoogleDriveInfoUseCase.self)!,
                observeDropboxInfoUseCase: r.resolve(ObserveDropboxInfoUseCase.self)!
            )
        }
        
        container.register(SettingsPageCoordinator.self) { r in
            SettingsPageCoordinator(navigationController: self.settingsPageNavigationController,
                                    resolver: r)
        }
        
        container.register(SettingsPageViewModel.self) { r in
            SettingsPageViewModel()
        }
    }
}
