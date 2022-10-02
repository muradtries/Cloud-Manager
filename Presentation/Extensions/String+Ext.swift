//
//  String+Ext.swift
//  Presentation
//
//  Created by Murad on 23.09.22.
//

import Foundation

extension String {
    var pathExtension: String {
        let string = self as NSString
        return string.pathExtension
    }
    
    var pathPrefix: String {
        let string = self as NSString
        return string.deletingPathExtension
    }
}
