//
//  UINavigationController+Ext.swift
//  Presentation
//
//  Created by Murad on 02.10.22.
//

import Foundation

extension UINavigationController {
    func customizeBackButton() {
        let backImage = UIImage(named: "BackButton")?.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: FontFamily.Poppins.regular
            .font(size: 16)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: FontFamily.Poppins.regular
            .font(size: 16)], for: .highlighted)
    }
}
