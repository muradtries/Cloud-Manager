//
//  DropboxPreviewFileController.swift
//  Presentation
//
//  Created by Murad on 23.09.22.
//

import Foundation
import WebKit
import SnapKit

class DropboxPreviewFileController: BaseViewController<DropboxPreviewFileViewModel> {
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        
        self.view.addSubview(view)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavBar()
        self.showSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.viewModel.checkFileExists() {
            print("FILE EXISTS AT GIVEN PATH")
            let previewURL = self.viewModel.previewFileURL
            
            if let previewURL = previewURL {
                self.webView.loadFileURL(previewURL, allowingReadAccessTo: previewURL)
                self.removeSpinner()
            }
        } else {
            print("FILE NOT EXIST AT GIVEN PATH")
            self.viewModel.downloadFile().then { _ in
                let previewURL = self.viewModel.previewFileURL
                
                if let previewURL = previewURL {
                    self.webView.loadFileURL(previewURL, allowingReadAccessTo: previewURL)
                    self.removeSpinner()
                }
            }
        }
    }
    
    override func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func setupUI() {
        
        self.view.backgroundColor = .white
        
        self.webView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    deinit {
        print("PREVIEW FILE VC DEALLOCATED")
    }
}
