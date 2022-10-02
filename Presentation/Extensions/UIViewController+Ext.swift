//
//  UIViewController+Ext.swift
//  Presentation
//
//  Created by Murad on 01.09.22.
//

import UIKit

private var spinnerView: UIView?

extension UIViewController {
    
    func showSpinner() {
        spinnerView = UIView(frame: self.view.bounds)
        spinnerView?.backgroundColor = UIColor.clear
        let ai = UIActivityIndicatorView(style: .large)
        ai.overrideUserInterfaceStyle = .light
        ai.center = spinnerView!.center
        ai.startAnimating()
        spinnerView?.addSubview(ai)
        self.view.addSubview(spinnerView!)
    }
    
    func removeSpinner() {
        spinnerView?.removeFromSuperview()
        spinnerView = nil
    }
}
