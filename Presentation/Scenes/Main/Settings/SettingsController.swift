//
//  SettingsController.swift
//  Presentation
//
//  Created by Murad on 06.09.22.
//

import Foundation
import SnapKit
import UIKit

class SettingsController: BaseViewController<SettingsPageViewModel> {
    
    private lazy var clearAllCache: UIButton = {
        let button = UIButton()
        
        self.view.addSubview(button)
        
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1.5
        button.setTitle("Clear cache", for: .normal)
        button.titleLabel?.font = FontFamily.Poppins.medium.font(size: 16)
        button.tintColor = .systemRed
        button.setImage(Asset.Icons.icDelete.image.resizedImage(size: CGSize(width: 20, height: 20))?.withTintColor(.systemRed), for: .normal)
        button.setImage(Asset.Icons.icDelete.image.resizedImage(size: CGSize(width: 20, height: 20))?.withTintColor(.systemRed), for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.addTarget(self, action: #selector(onClearCache), for: .touchUpInside)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavBar()
    }
    
    override func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: FontFamily.Poppins.medium.font(size: 32),
                                                                        NSAttributedString.Key.foregroundColor:
                                                                            UIColor.darkText]
    }
    
    override func setupUI() {
        
        self.title = "Settings"
        
        self.view.backgroundColor = .white
        
        self.clearAllCache.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.centerY.equalTo(self.view.safeAreaLayoutGuide.snp.centerY)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    @objc func onClearCache() {
        do {
            try self.viewModel.clearAllFilesCache()
            let popUP = TopPopUpAlert()
            popUP.setupPopUp(with: Asset.Icons.icDelete.image, descriptionText: "Cleared cached files successfully!", backgroundColor: UIColor.systemGreen)
            popUP.show(viewController: self)
        } catch {
            print("ERROR OCCURED WHILE WRITING TO DISK \(error.localizedDescription)")
            let popUP = TopPopUpAlert()
            popUP.setupPopUp(with: Asset.Icons.icDelete.image, descriptionText: "Cleared cached files successfully!", backgroundColor: UIColor.systemGreen)
            popUP.show(viewController: self)
        }
    }
}
