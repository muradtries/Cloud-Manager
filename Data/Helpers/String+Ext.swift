//
//  String+Ext.swift
//  Data
//
//  Created by Murad on 22.09.22.
//

import Foundation

extension String {
    var pathExtension: String {
        let string = self as NSString
        return string.pathExtension
    }
    
    var removeIDPrefix: Substring {
        return self.dropFirst(3)
    }
}
