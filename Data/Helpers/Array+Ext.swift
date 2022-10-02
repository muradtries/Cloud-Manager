//
//  Array+Ext.swift
//  Data
//
//  Created by Murad on 04.09.22.
//

import Foundation

extension Array where Element: Comparable {
    func sharesSameElements(with other: [Element]) -> Bool {
        let sharedElements = self.filter() { other.contains($0) }
        return sharedElements.count == other.count && sharedElements.sorted() == other.sorted()
    }
}
