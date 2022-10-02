//
//  SFSafariViewController+Ext.swift
//  Presentation
//
//  Created by Murad on 09.09.22.
//

import SafariServices

extension SFSafariViewController {
    override open var modalPresentationStyle: UIModalPresentationStyle {
        get { return .fullScreen }
        set { super.modalPresentationStyle = newValue }
    }
}
