//
//  SplashPresenter.swift
//  Presentation
//
//  Created by Murad on 05.10.22.
//

import UIKit

public protocol SplashPresenterDescription: AnyObject {
    func present()
    func dismiss(completion: @escaping () -> Void)
}

public final class SplashPresenter: SplashPresenterDescription {
    
    // MARK: - Properties
    
    private lazy var animator: SplashAnimatorDescription = SplashAnimator(foregroundSplashWindow: foregroundSplashWindow,
                                                                          backgroundSplashWindow: backgroundSplashWindow)
    
    private lazy var foregroundSplashWindow: UIWindow = {
        let splashViewController = self.splashViewController(logoIsHidden: false)
        let splashWindow = self.splashWindow(windowLevel: .normal + 1, rootViewController: splashViewController)
        
        return splashWindow
    }()
    
    private lazy var backgroundSplashWindow: UIWindow = {
        let splashViewController = self.splashViewController(logoIsHidden: true)
        let splashWindow = self.splashWindow(windowLevel: .normal - 1, rootViewController: splashViewController)
        
        return splashWindow
    }()
    
    public init() {
        // making initializer accessible
    }
    
    // MARK: - Helpers
    
    private func splashWindow(windowLevel: UIWindow.Level, rootViewController: SplashController?) -> UIWindow {
        let splashWindow = UIWindow(frame: UIScreen.main.bounds)
        
        splashWindow.windowLevel = windowLevel
        splashWindow.rootViewController = rootViewController
        
        return splashWindow
    }
    
    private func splashViewController(logoIsHidden: Bool) -> SplashController {
        let splashViewController = SplashController()
        
        splashViewController.logoIsHidden = logoIsHidden
        
        return splashViewController
    }
    
    // MARK: - SplashPresenterDescription
    
    public func present() {
        animator.animateAppearance()
    }
    
    public func dismiss(completion: @escaping () -> Void) {
        animator.animateDisappearance(completion: completion)
    }
    
}
