//
//  UIStackView+Ext.swift
//  Presentation
//
//  Created by Murad on 06.10.22.
//

extension UIStackView {

    func reverseSubviewsZIndex(setNeedsLayout: Bool = true) {
        let stackedViews = self.arrangedSubviews

        stackedViews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        stackedViews.reversed().forEach(addSubview(_:))
        stackedViews.reversed().forEach(addArrangedSubview(_:))

        if setNeedsLayout {
            stackedViews.forEach { $0.setNeedsLayout() }
        }
    }
}
