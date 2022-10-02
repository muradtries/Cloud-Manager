//
//  RenamePopUpController.swift
//  Presentation
//
//  Created by Murad on 16.09.22.
//

import Foundation
import SnapKit
import Domain

protocol RenamePopUpControllerDelegate: AnyObject {
    func didCancelRenaming()
    func didApprovedRenaming(to newName: String)
}

class RenamePopUpController: UIViewController {
    
    weak var delegate: RenamePopUpControllerDelegate?
    
    private var fileExtension: String?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        self.view.addSubview(view)
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    private lazy var renameLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.font = FontFamily.Poppins.regular.font(size: 16)
        label.text = "Rename:"
        label.textColor = .darkText
        
        return label
    }()
    
    private lazy var renameTextField: UITextField = {
        let view = UITextField()
        
        self.contentView.addSubview(view)
        
        view.placeholder = "New name"
        view.textColor = .darkText
        view.font = FontFamily.Poppins.regular.font(size: 14)
        view.addBorder(to: .bottom, color: .systemBlue, thickness: 1.0)
        
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        self.contentView.addSubview(button)
        
        button.setTitle("Cancel", for: .normal)
        button.setTitle("Cancel", for: .selected)
        
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemBlue, for: .selected)
        
        button.titleLabel?.font = FontFamily.Poppins.regular.font(size: 14)
        
        button.addTarget(self, action: #selector(onTapCancel), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var renameButton: UIButton = {
        let button = UIButton()
        
        self.contentView.addSubview(button)
        
        button.setTitle("Rename", for: .normal)
        button.setTitle("Rename", for: .selected)
        
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemBlue, for: .selected)
        
        button.titleLabel?.font = FontFamily.Poppins.regular.font(size: 14)
        
        button.addTarget(self, action: #selector(onTapRename), for: .touchUpInside)
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        self.renameTextField.addBottomBorder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.renameTextField.becomeFirstResponder()
    }
    
    deinit {
        print("RENAME POP UP DEALLOCATED")
    }
    
    private func setupUI() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        self.contentView.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width / 1.3)
            make.center.equalToSuperview()
        }
        
        self.renameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-8)
        }
        
        self.renameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.renameLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.renameButton.snp.centerY)
            make.right.equalTo(self.renameButton.snp.left).offset(-12)
        }
        
        self.renameButton.snp.makeConstraints { make in
            make.top.equalTo(self.renameTextField.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func putCurrentNameIntoField(name: String, isFolder: Bool) {
        if isFolder {
            self.renameTextField.text = name
        } else {
            self.renameTextField.text = name.pathPrefix
        }
        self.fileExtension = name.pathExtension
    }
 
    @objc private func textFieldDidChange() {
        if self.renameTextField.text!.isEmpty {
            self.renameButton.isUserInteractionEnabled = false
            self.renameButton.setTitleColor(UIColor.systemGray, for: .normal)
        } else {
            self.renameButton.isUserInteractionEnabled = true
            self.renameButton.setTitleColor(UIColor.systemBlue, for: .normal)
        }
    }
    
    @objc private func onTapCancel() {
        delegate?.didCancelRenaming()
        self.dismiss(animated: true)
    }
    
    @objc private func onTapRename() {
        delegate?.didApprovedRenaming(to: self.renameTextField.text!)
        self.dismiss(animated: true)
    }
}

extension UITextField {
    func addBottomBorder() {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0,
                                  y: frame.size.height-1,
                                  width: frame.size.width,
                                  height: 1)
        
        bottomLine.backgroundColor = UIColor.systemBlue.cgColor
        
        borderStyle = .none
        
        layer.addSublayer(bottomLine)
        
        layer.masksToBounds = true
    }
}
