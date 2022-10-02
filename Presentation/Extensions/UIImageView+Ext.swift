//
//  UIImageView+Ext.swift
//  Presentation
//
//  Created by Murad on 11.09.22.
//

import UIKit

extension UIImageView {
    func loadImage(url: String) {
        if let url = URL(string: url) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
