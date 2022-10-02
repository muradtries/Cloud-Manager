//
//  ConnectServiceView.swift
//  Presentation
//
//  Created by Murad on 28.09.22.
//

import Foundation
import SnapKit

protocol ConnectServiceViewDelegate: AnyObject {
    func didTap(service: ServiceModel)
}

class ConnectServiceView: UIView {
    let notificationCenter = NotificationCenter.default
    
    weak var delegate: ConnectServiceViewDelegate?
    
    var service: ServiceModel!
    
    private lazy var serviceIcon: UIImageView = {
        let view = UIImageView()
        
        self.addSubview(view)
        
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private lazy var serviceName: UILabel = {
        let label = UILabel()
        
        self.addSubview(label)
        
        label.font = FontFamily.Poppins.medium.font(size: 16)
        
        return label
    }()
    
    private lazy var cloudIcon: UIImageView = {
        let view = UIImageView()
        
        self.addSubview(view)
        
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGestures()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        self.serviceIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        self.serviceName.snp.makeConstraints { make in
            make.left.equalTo(self.serviceIcon.snp.right).offset(12)
            make.right.lessThanOrEqualTo(self.cloudIcon.snp.left).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        self.cloudIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapCloud(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupService(service: ServiceModel) {
        self.service = service
        self.serviceIcon.image = service.icon
        
        switch service.state {
        case .connected:
            self.serviceName.text = "Disconnect \(service.name)"
            self.serviceName.textColor = .systemRed
            self.cloudIcon.image = Asset.icCloudOn.image.resizedImage(Size: CGSize(width: 24, height: 24))?.withTintColor(.systemGreen)
        case .disconnected:
            self.serviceName.text = "Connect \(service.name)"
            self.serviceName.textColor = .systemGreen
            self.cloudIcon.image = Asset.icCloudOff.image.resizedImage(Size: CGSize(width: 24, height: 24))?.withTintColor(.systemRed)
        }
    }
    
    @objc func onTapCloud(_ sender: UITapGestureRecognizer) {
        print("onTapCloud")
        delegate?.didTap(service: self.service)
    }
}
