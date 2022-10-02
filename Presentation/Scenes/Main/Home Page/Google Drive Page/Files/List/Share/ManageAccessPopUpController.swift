//
//  ManageAccessPopUpController.swift
//  Presentation
//
//  Created by Murad on 17.09.22.
//

import Foundation
import SnapKit
import RxCocoa

class ManageAccessPopUpController: BaseViewController<ManageAccessViewModel> {
    
    var accessStatus: ScopeOption?
    
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
        
        label.font = FontFamily.Poppins.medium.font(size: 18)
        label.textColor = .darkText
        label.text = "Share \(viewModel.file?.name ?? "Null")"
        
        return label
    }()
    
    private lazy var generalAccess: UILabel = {
        let view = UILabel()
        
        self.contentView.addSubview(view)
        
        view.text = "General Access"
        view.textColor = .darkText
        view.font = FontFamily.Poppins.regular.font(size: 16)
        
        return view
    }()
    
    private lazy var accessStatusIcon: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        
        self.contentView.addSubview(view)
        
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.backgroundColor = UIColor.lightGray.cgColor
        view.tintColor = .darkGray
        let image = Asset.icLock.image.resizedImage(Size: CGSize(width: 18, height: 18))?.withTintColor(.darkGray)
        view.contentMode = .center
        view.image = image
        
        return view
    }()
    
    private lazy var scopeOptionsButton: UIButton = {
        let button = UIButton()
        
        self.contentView.addSubview(button)
        
        button.contentHorizontalAlignment = .left
        
        button.setTitle("Anyone with link", for: .normal)
        button.titleLabel?.font = FontFamily.Poppins.regular.font(size: 14)
        
        let oldImage = Asset.icExpandMore.image
        let newImage = oldImage.resizedImage(Size: CGSize(width: 20, height: 20))
        
        button.setImage(newImage, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        
        button.setTitleColor(.darkText, for: .normal)
        
        button.addTarget(self, action: #selector(onTapScopeOptions), for: .touchUpInside)
        button.showsMenuAsPrimaryAction = true
        
        let restrictedAction : UIAction = .init(title: "Restricted", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), handler: { [weak self](action) in
            self?.accessStatus = .restricted
            self?.prepareForRestrictedStatus()
        })
        
        let anyoneWithLinkAction : UIAction = .init(title: "Anyone with link", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), handler: { [weak self](action) in
            self?.accessStatus = .anyoneWithLink(.viewer)
            self?.prepareForPublicStatus()
        })
        
        let actions = [restrictedAction, anyoneWithLinkAction]
        
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: actions)
        
        button.menu = menu
        
        return button
    }()
    
    private lazy var accessRole: UIButton = {
        let button = UIButton()
        
        self.contentView.addSubview(button)
        
        button.contentHorizontalAlignment = .left
        
        button.setTitle("Viewer", for: .normal)
        button.titleLabel?.font = FontFamily.Poppins.regular.font(size: 14)
        
        let oldImage = Asset.icExpandMore.image
        let newImage = oldImage.resizedImage(Size: CGSize(width: 20, height: 20))
        
        button.setImage(newImage, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        
        button.setTitleColor(.darkText, for: .normal)
        
        button.addTarget(self, action: #selector(onTapScopeOptions), for: .touchUpInside)
        button.showsMenuAsPrimaryAction = true
        
        let viewerAction : UIAction = .init(title: "Viewer", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), handler: { [weak self](action) in
            self?.accessStatus = .anyoneWithLink(.viewer)
            self?.accessRole.setTitle("Viewer", for: .normal)
        })
        
        let commenterAction : UIAction = .init(title: "Commenter", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), handler: { [weak self](action) in
            self?.accessStatus = .anyoneWithLink(.commenter)
            self?.accessRole.setTitle("Commenter", for: .normal)
        })
        
        let editorAction : UIAction = .init(title: "Editor", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), handler: { [weak self](action) in
            self?.accessStatus = .anyoneWithLink(.editor)
            self?.accessRole.setTitle("Editor", for: .normal)
        })
        
        let actions = [viewerAction, commenterAction, editorAction]
        
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: actions)
        
        button.menu = menu
        
        return button
    }()
    
    private lazy var copyLinkButton: UIButton = {
        
        let button = UIButton()
        
        self.contentView.addSubview(button)
        
        button.addTarget(self, action: #selector(onTapCopyLink), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.tintColor = .systemBlue
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.bordered()
            configuration.baseBackgroundColor = .white
            configuration.buttonSize = .small
            configuration.image = Asset.icLink.image.resizedImage(Size: CGSize(width: 16, height: 16))?.withTintColor(.systemBlue)
            configuration.imagePadding = 6
            configuration.imagePlacement = .leading
            configuration.attributedTitle = AttributedString("Copy link", attributes: AttributeContainer([NSAttributedString.Key.font: FontFamily.Poppins.medium.font(size: 14)]))
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            button.configuration = configuration
        } else {
            button.setTitle("Copy link", for: .normal)
            button.setTitle("Copy link", for: .selected)
            
            button.setTitleColor(.systemBlue, for: .normal)
            button.setTitleColor(.systemBlue, for: .selected)
        }
        
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        
        self.contentView.addSubview(button)
        
        button.addTarget(self, action: #selector(onTapDone), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.tintColor = .white
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.bordered()
            configuration.baseBackgroundColor = .systemBlue
            configuration.attributedTitle = AttributedString("Done", attributes: AttributeContainer([NSAttributedString.Key.font: FontFamily.Poppins.medium.font(size: 14)]))
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
            button.configuration = configuration
        } else {
            button.setTitle("Done", for: .normal)
            button.setTitle("Done", for: .selected)
            
            button.setTitleColor(.systemBlue, for: .normal)
            button.setTitleColor(.systemBlue, for: .selected)
        }
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        print("SHARING OPTIONS POP UP DEALLOCATED")
    }
    
    override func setupUI() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        self.contentView.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width / 1.1)
            make.center.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-8)
        }
        
        self.generalAccess.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.left.equalTo(self.titleLabel.snp.left)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.accessStatusIcon.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(self.generalAccess.snp.bottom).offset(8)
            make.left.equalTo(self.titleLabel.snp.left)
        }
        
        self.scopeOptionsButton.snp.makeConstraints { make in
            make.left.equalTo(self.accessStatusIcon.snp.right).offset(10)
            make.centerY.equalTo(self.accessStatusIcon.snp.centerY)
        }
        
        self.accessRole.snp.makeConstraints { make in
            make.centerY.equalTo(self.scopeOptionsButton.snp.centerY)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.copyLinkButton.snp.makeConstraints { make in
            make.top.equalTo(self.scopeOptionsButton.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        self.doneButton.snp.makeConstraints { make in
            make.top.equalTo(self.scopeOptionsButton.snp.bottom).offset(40)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func setupData() {
        if let file = viewModel.file {
            switch file.shared {
            case true:
                prepareForPublicStatus()
                accessRole.setTitle(file.permission.role.rawValue.capitalized, for: .normal)
            case false:
                prepareForRestrictedStatus()
            }
        }
    }
    
    private func prepareForRestrictedStatus() {
        accessStatusIcon.backgroundColor = .lightGray
        accessStatusIcon.image = Asset.icLock.image.resizedImage(Size: CGSize(width: 18, height: 18))?.withTintColor(.darkGray)
        scopeOptionsButton.setTitle("Restricted", for: .normal)
        accessRole.isHidden = true
    }
    
    private func prepareForPublicStatus() {
        accessStatusIcon.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        accessStatusIcon.image = Asset.icPublic.image.resizedImage(Size: CGSize(width: 18, height: 18))?.withTintColor(.systemGreen)
        scopeOptionsButton.setTitle("Anyone with link", for: .normal)
        accessRole.isHidden = false
    }
    
    @objc private func onTapScopeOptions() {
        print("Someone tapped me!")
    }
    
    @objc private func onTapCopyLink() {
        self.viewModel.didCopiedLinkToClipBoard(viewController: self)
    }
    
    @objc private func onTapDone() {
        switch accessStatus {
        case .restricted:
            print("restricted")
            viewModel.didFinishedEditingOptions(role: .restricted).then { _ in
                print("SUCCESSFULLY RESTRICTED FILE")
                self.viewModel.delegate?.didFinishedManagingAccess()
            }
            self.dismiss(animated: true)
        case .anyoneWithLink(let role):
            viewModel.didFinishedEditingOptions(role: .anyoneWithLink(role)).then { _ in
                print("SUCCESSFULLY SHARED FILE WITH ANYONE WITH LINK")
                self.viewModel.delegate?.didFinishedManagingAccess()
            }
            print(role.rawValue)
            self.dismiss(animated: true)
        case .none:
            self.dismiss(animated: true)
            return
        }
    }
}
