//
//  SplashAnimator.swift
//  Presentation
//
//  Created by Murad on 05.10.22.
//

import Foundation

public protocol SplashAnimatorDescription: AnyObject {
    func animateAppearance()
    func animateDisappearance(completion: @escaping () -> Void)
}

public final class SplashAnimator: SplashAnimatorDescription {
    
    private unowned let foregroundSplashWindow: UIWindow
    private unowned let backgroundSplashWindow: UIWindow
    
    private unowned let foregroundSplashViewController: SplashController
    private unowned let backgroundSplashViewController: SplashController
    
    init(foregroundSplashWindow: UIWindow, backgroundSplashWindow: UIWindow) {
        self.foregroundSplashWindow = foregroundSplashWindow
        self.backgroundSplashWindow = backgroundSplashWindow
        
        guard
            let foregroundSplashViewController = foregroundSplashWindow.rootViewController as? SplashController,
            let backgroundSplashViewController = backgroundSplashWindow.rootViewController as? SplashController else {
                fatalError("Splash window doesn't have splash root view controller!")
        }
        
        self.foregroundSplashViewController = foregroundSplashViewController
        self.backgroundSplashViewController = backgroundSplashViewController
    }
    
    public func animateAppearance() {
        foregroundSplashWindow.isHidden = false
    }
    
    // MARK: - Disappearance
    
    public func animateDisappearance(completion: @escaping () -> Void) {
        guard let window = UIApplication.shared.delegate?.window, let mainWindow = window else {
            fatalError("Application doesn't have a window!")
        }
        
        // Background splash window provides splash behind the animated logo image instead of black screen
        backgroundSplashWindow.isHidden = false
        foregroundSplashWindow.alpha = 0
        
        // This mask provides hole in window with shape of logo image
        let mask = CALayer()
        mask.frame = foregroundSplashViewController.imageView.frame
        mask.contents = SplashController.logoImageBig.cgImage
        mask.contentsGravity = .resizeAspect
        mainWindow.layer.mask = mask
        
        // Fading UIView
        let maskBackgroundView = UIView()
        maskBackgroundView.frame = mainWindow.frame
        maskBackgroundView.backgroundColor = .white
        mainWindow.addSubview(maskBackgroundView)
        mainWindow.bringSubviewToFront(maskBackgroundView)
        
        CATransaction.setCompletionBlock {
            mainWindow.layer.mask = nil
            completion()
        }
        
        CATransaction.begin()
        
        mainWindow.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        UIView.animate(withDuration: 0.4, animations: {
            mainWindow.transform = .identity
        })
        
        addScalingAnimation(to: mask, duration: 0.4)
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [], animations: {
            maskBackgroundView.alpha = 0
        }) { _ in
            maskBackgroundView.removeFromSuperview()
        }
        
        CATransaction.commit()
    }
    
    private func addScalingAnimation(to layer: CALayer, duration: TimeInterval, delay: CFTimeInterval = 0) {
        let animation = CAKeyframeAnimation(keyPath: "bounds")
        
        let width = layer.frame.size.width
        let height = layer.frame.size.height
        let coeficient: CGFloat = 36 / 667
        let finalScale = UIScreen.main.bounds.height * coeficient
        let scales = [1, 0.75, finalScale]
        
        animation.beginTime = CACurrentMediaTime() + delay
        animation.duration = duration
        animation.keyTimes = [0, 0.4, 1]
        animation.values = scales.map { NSValue(cgRect: CGRect(x: 0, y: 0, width: width * $0, height: height * $0)) }
        animation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
                                     CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)]
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        layer.add(animation, forKey: "scaling")
    }
}
