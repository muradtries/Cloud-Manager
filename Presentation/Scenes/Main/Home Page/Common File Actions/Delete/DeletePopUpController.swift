//
//  DeletePopUpController.swift
//  Presentation
//
//  Created by Murad on 20.09.22.
//

import Foundation
import SnapKit

protocol DeletePopUpControllerDelegate: AnyObject {
    func didCancelDeleting()
    func didApprovedDeleting()
}

class DeletePopUpController: UIViewController {
    
    weak var delegate: DeletePopUpControllerDelegate?
    
    var fileName: String?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        self.view.addSubview(view)
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.font = FontFamily.Poppins.medium.font(size: 16)
        label.text = "Move to trash?"
        label.textColor = .darkText
        
        return label
    }()
    
    private lazy var disclaimerLabel: UILabel = {
        let view = UILabel()
        
        self.contentView.addSubview(view)
        
        view.text = #""\#(fileName ?? "Null")" will be deleted forever after 30 days."#
        view.textColor = .darkText
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.font = FontFamily.Poppins.regular.font(size: 14)
        
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
        
        button.setTitle("Move to trash", for: .normal)
        button.setTitle("Move to trash", for: .selected)
        
        button.setTitleColor(.systemRed, for: .normal)
        button.setTitleColor(.systemRed, for: .selected)
        
        button.titleLabel?.font = FontFamily.Poppins.medium.font(size: 14)
        
        button.addTarget(self, action: #selector(onTapRename), for: .touchUpInside)
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        print("DELETE POP UP DEALLOCATED")
    }
    
    private func setupUI() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        self.contentView.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width / 1.15)
            make.center.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-8)
        }
        
        self.disclaimerLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-8)
        }
        
        self.cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.renameButton.snp.centerY)
            make.right.equalTo(self.renameButton.snp.left).offset(-12)
        }
        
        self.renameButton.snp.makeConstraints { make in
            make.top.equalTo(self.disclaimerLabel.snp.bottom).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    @objc private func onTapCancel() {
        delegate?.didCancelDeleting()
        self.dismiss(animated: true)
    }
    
    @objc private func onTapRename() {
        delegate?.didApprovedDeleting()
        self.dismiss(animated: true)
    }
}

