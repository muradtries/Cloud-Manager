//
//  AppDelegate.swift
//  Cloud-Manager
//
//  Created by Murad on 28.08.22.
//

import UIKit
import Data
import Domain
import Presentation
import Swinject
import SwiftyDropbox
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var assembler: Assembler?
    var appCoordinator: AppCoordinator?
    private var splashPresenter: SplashPresenterDescription? = SplashPresenter()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        DropboxClientsManager.setupWithAppKey("h9wid8lsnxjnyvq")
        
        let homePageNavigationController = UINavigationController()
        let settingsPageNavigationController = UINavigationController()
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = .white
        tabBarController.tabBar.tintColor = .systemBlue
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.isTranslucent = false
        
        assembler = Assembler([
            DataAssembly(),
            DomainAssembly(),
            PresentationAssembly(homePageNavigationController: homePageNavigationController, settingsPageNavigationController: settingsPageNavigationController, tabBarController: tabBarController)
        ])
        
        if let assembler = assembler {
            self.appCoordinator = AppCoordinator(resolver: assembler.resolver)
        }
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        splashPresenter?.present()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.splashPresenter?.dismiss { [weak self] in
                self?.splashPresenter = nil
            }
        }
        
        self.appCoordinator?.start()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var handled: Bool
        
        let oauthCompletion: DropboxOAuthCompletion = { result in
            
            if let authResult = result {
                switch authResult {
                case .success:
                    print("Success! User is logged into DropboxClientsManager.")
                    UIApplication.authSuccessPromise.fulfill(Void())
                    
                    UserDefaults.standard.set(true, forKey: "connectedDropbox")
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: Notification.Name("ConnectedDropbox"), object: nil)
                case .cancel:
                    print("Authorization flow was manually canceled by user!")
                    UIApplication.authSuccessPromise.reject(NSError(domain: "cancel", code: 1))
                case .error(let error, let description):
                    print("Error: \(String(describing: description))")
                    UIApplication.authSuccessPromise.reject(error)
                }
            }
        }
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        let canHandleUrl = DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
        return canHandleUrl 
    }
}

