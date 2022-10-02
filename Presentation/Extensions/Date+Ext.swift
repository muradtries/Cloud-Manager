//
//  Date+Ext.swift
//  Presentation
//
//  Created by Murad on 20.09.22.
//

import Foundation

extension Date {
    var stringFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let string = dateFormatter.string(from: self)
        
        return string
    }
}
