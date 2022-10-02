//
//  ConnectServicesController.swift
//  Presentation
//
//  Created by Murad on 28.09.22.
//

import Foundation
import SnapKit

protocol ConnectServicesDelegate: AnyObject {
    func requestedToConnectToGoogleDrive()
    func requestedToConnectToDropbox()
    func requestedToDisconnectGoogleDrive()
    func requestedToDisconnectDropbox()
}

class ConnectServicesController: UIViewController {
    
    weak var delegate: ConnectServicesDelegate?
    
    private lazy var drawer: UIView = {
        let view = UIView()
        
        self.view.addSubview(view)
        
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        
        self.view.addSubview(view)
        
        view.distribution = .equalSpacing
        view.spacing = 6
        view.axis = .vertical
        
        return view
    }()
    
    private lazy var googleDriveService: ConnectServiceView = {
        let view = ConnectServiceView()
        
        self.view.addSubview(view)
        
        if UserDefaults.standard.bool(forKey: "connectedGoogleDrive") {
            view.setupService(service: ServiceModel(name: "Google Drive", icon: Asset.icDrive.image, state: .connected))
        } else {
            view.setupService(service: ServiceModel(name: "Google Drive", icon: Asset.icDrive.image, state: .disconnected))
        }
        
        view.delegate = self
        
        return view
    }()
    
    private lazy var dropboxService: ConnectServiceView = {
        let view = ConnectServiceView()
        
        self.view.addSubview(view)
        
        if UserDefaults.standard.bool(forKey: "connectedDropbox") {
            view.setupService(service: ServiceModel(name: "Dropbox", icon: Asset.icDropbox.image, state: .connected))
        } else {
            view.setupService(service: ServiceModel(name: "Dropbox", icon: Asset.icDropbox.image, state: .disconnected))
        }
        
        view.delegate = self
        
        return view
    }()
    
    override func viewDidLoad() {
        setupUI()
    }
    
    deinit {
        print("CONNECT SERVICES VC DEALLOCATED")
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        
        self.stackView.addArrangedSubview(self.googleDriveService)
        self.stackView.addArrangedSubview(self.dropboxService)
        
        self.drawer.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(4)
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
        }
        
        self.stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
    }
}

extension ConnectServicesController: ConnectServiceViewDelegate {
    
    func didTap(service: ServiceModel) {
        print("\(service)")
        
        
        self.dismiss(animated: true) { [weak self] in
            switch service.icon {
            case Asset.icDrive.image:
                switch service.state {
                case .connected:
                    self?.delegate?.requestedToDisconnectGoogleDrive()
                case .disconnected:
                    self?.delegate?.requestedToConnectToGoogleDrive()
                }
            case Asset.icDropbox.image:
                switch service.state {
                case .connected:
                    self?.delegate?.requestedToDisconnectDropbox()
                case .disconnected:
                    self?.delegate?.requestedToConnectToDropbox()
                }
            default:
                return
            }
        }
    }
}
