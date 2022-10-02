//
//  GoogleDriveInfoView.swift
//  Presentation
//
//  Created by Murad on 09.09.22.
//

import Foundation
import Domain
import SnapKit
import UIKit

private enum Storage: String {
    case limit = "storageLimit"
    case driveUsage = "driveUsage"
    case otherUsage = "otherUsage"
    case allUsage = "allUsage"
}

class GoogleDriveInfoView: UIView {
    
    var onlyDriveRatio: Double = 0.0
    var totalDriveRatio: Double = 0.0
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        self.addSubview(view)
        
        return view
    }()
    
    private lazy var serviceIcon: UIImageView = {
        let view = UIImageView()
        
        self.contentView.addSubview(view)
        
        view.image = Asset.icDrive.image
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var serviceName: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.text = "Google Drive"
        label.textColor = .darkText
        label.font = FontFamily.Poppins.regular.font(size: 18)
        
        return label
    }()
    
    private lazy var userProfilePicture: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        self.contentView.addSubview(view)
        
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = view.frame.width / 2
        view.clipsToBounds = true

        return view
    }()
    
    private lazy var userDisplayName: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.text = "Not Found"
        label.textColor = .darkText
        label.font = FontFamily.Poppins.medium.font(size: 18)
        
        return label
    }()
    
    private lazy var userEmail: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.text = "not found"
        label.textColor = UIColor(red: 0.621, green: 0.65, blue: 0.654, alpha: 1)
        label.font = FontFamily.Poppins.medium.font(size: 12)
        
        return label
    }()
    
    private lazy var storageQuotaLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.text = "Null GB* of Null GB is used"
        label.textColor = .darkText
        label.font = FontFamily.Poppins.regular.font(size: 12)
        
        return label
    }()
    
    private lazy var usageGraph: UIView = {
        let view = UIView()
        
        self.contentView.addSubview(view)
        
        view.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    private lazy var totalStorageUsageGraph: UIView = {
        let view = UIView()
        
        self.contentView.addSubview(view)
        
        view.backgroundColor = UIColor(red: 0.945, green: 0.749, blue: 0.259, alpha: 1)
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    private lazy var googleDriveStorageUsageGraph: UIView = {
        let view = UIView()
        
        self.contentView.addSubview(view)
        
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(red: 0.318, green: 0.502, blue: 0.906, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        return view
    }()
    
    private lazy var googleDriveCircle: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        
        self.contentView.addSubview(view)
        
        view.backgroundColor = UIColor(red: 0.318, green: 0.502, blue: 0.906, alpha: 1)
        view.layer.cornerRadius = view.frame.width / 2
        
        return view
    }()
    
    private lazy var googleDriveServiceLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.text = "Google Drive"
        label.textColor = UIColor(red: 0.621, green: 0.65, blue: 0.654, alpha: 1)
        label.font = FontFamily.Poppins.regular.font(size: 10)
        
        return label
    }()
    
    private lazy var googleDriveStorageUsageLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.text = "Null"
        label.textColor = UIColor(red: 0.621, green: 0.65, blue: 0.654, alpha: 1)
        label.font = FontFamily.Poppins.regular.font(size: 10)
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var otherServicesCircle: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        
        self.contentView.addSubview(view)
        
        view.backgroundColor = UIColor(red: 0.945, green: 0.749, blue: 0.259, alpha: 1)
        view.layer.cornerRadius = view.frame.width / 2
        
        return view
    }()
    
    private lazy var otherServicesLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.text = "Other Services"
        label.textColor = UIColor(red: 0.621, green: 0.65, blue: 0.654, alpha: 1)
        label.font = FontFamily.Poppins.regular.font(size: 10)
        
        return label
    }()
    
    private lazy var otherServicesStorageUsageLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.text = "Null"
        label.textColor = UIColor(red: 0.621, green: 0.65, blue: 0.654, alpha: 1)
        label.font = FontFamily.Poppins.regular.font(size: 10)
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var disclaimerText: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.text = "*For the informational purposes, this shown quota is the total with other services(Gmail, Google Photos)"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor(red: 0.621, green: 0.65, blue: 0.654, alpha: 1)
        label.font = FontFamily.Poppins.regular.font(size: 9)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 16
        
        self.contentView.bringSubviewToFront(self.usageGraph)
        self.contentView.bringSubviewToFront(self.totalStorageUsageGraph)
        self.contentView.bringSubviewToFront(self.googleDriveStorageUsageGraph)
        
        self.contentView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        self.serviceIcon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(24)
        }
        
        self.serviceName.snp.makeConstraints { make in
            make.left.equalTo(self.serviceIcon.snp.right).offset(10)
            make.centerY.equalTo(self.serviceIcon.snp.centerY)
        }
        
        self.userProfilePicture.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(self.serviceIcon.snp.centerY)
            make.right.equalToSuperview().offset(-24)
        }
        
        self.userDisplayName.snp.makeConstraints { make in
            make.top.equalTo(self.serviceIcon.snp.bottom).offset(24)
            make.left.equalTo(self.serviceIcon.snp.left)
            make.right.lessThanOrEqualToSuperview().offset(-24)
        }
        
        self.userEmail.snp.makeConstraints { make in
            make.top.equalTo(self.userDisplayName.snp.bottom).offset(2)
            make.left.equalTo(self.serviceIcon.snp.left)
            make.right.equalTo(self.userDisplayName.snp.right)
        }
        
        self.storageQuotaLabel.snp.makeConstraints { make in
            make.top.equalTo(self.userEmail.snp.bottom).offset(10)
            make.left.equalTo(self.serviceIcon.snp.left)
            make.right.equalTo(self.userDisplayName.snp.right)
        }
        
        self.usageGraph.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.top.equalTo(self.storageQuotaLabel.snp.bottom).offset(6)
            make.left.equalTo(self.serviceIcon.snp.left)
            make.right.equalToSuperview().offset(-24)
        }
        
        self.googleDriveStorageUsageGraph.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(self.usageGraph.snp.width).multipliedBy(0.1)
            make.top.equalTo(self.usageGraph.snp.top)
            make.left.equalTo(self.serviceIcon.snp.left)
            make.right.lessThanOrEqualTo(self.usageGraph.snp.right)
        }
        
        self.totalStorageUsageGraph.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(self.usageGraph.snp.width).multipliedBy(0.1)
            make.top.equalTo(self.usageGraph.snp.top)
            make.left.equalTo(self.serviceIcon.snp.left)
            make.right.lessThanOrEqualTo(self.usageGraph.snp.right)
        }
        
        self.googleDriveCircle.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.top.equalTo(self.usageGraph.snp.bottom).offset(14)
            make.left.equalTo(self.serviceIcon.snp.left)
        }
        
        self.googleDriveServiceLabel.snp.makeConstraints { make in
            make.left.equalTo(self.googleDriveCircle.snp.right).offset(8)
            make.centerY.equalTo(self.googleDriveCircle.snp.centerY)
            make.right.lessThanOrEqualTo(self.googleDriveStorageUsageLabel.snp.right).offset(-12)
        }
        
        self.googleDriveStorageUsageLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalTo(self.googleDriveCircle.snp.centerY)
        }
        
        self.otherServicesCircle.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.top.equalTo(self.googleDriveCircle.snp.bottom).offset(6)
            make.left.equalTo(self.serviceIcon.snp.left)
        }
        
        self.otherServicesLabel.snp.makeConstraints { make in
            make.left.equalTo(self.otherServicesCircle.snp.right).offset(8)
            make.centerY.equalTo(self.otherServicesCircle.snp.centerY)
            make.right.lessThanOrEqualTo(self.otherServicesStorageUsageLabel.snp.right).offset(-12)
        }
        
        self.otherServicesStorageUsageLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalTo(self.otherServicesCircle.snp.centerY)
        }
        
        self.disclaimerText.snp.makeConstraints { make in
            make.top.equalTo(self.otherServicesCircle.snp.bottom).offset(10)
            make.left.equalTo(self.usageGraph.snp.left)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    func fillInfoView(with data: GoogleDriveInfoEntity) {
        let dict = makeUsageDictionary(data: data)
        self.userDisplayName.text = data.ownerDisplayName
        self.userEmail.text = data.ownerEmailAdress
        self.userProfilePicture.loadImage(url: data.profilePhotoLink)
        self.storageQuotaLabel.text = "\(dict[Storage.allUsage.rawValue] ?? "Null")* of \(dict[Storage.limit.rawValue] ?? "Null") is used"
        self.googleDriveStorageUsageLabel.text = "\(dict[Storage.driveUsage.rawValue] ?? "Null")"
        self.otherServicesStorageUsageLabel.text = "\(dict[Storage.otherUsage.rawValue] ?? "Null")"
        
        setupUsageIndicators(data: data)
    }
}

extension GoogleDriveInfoView {
    private func makeUsageDictionary(data: GoogleDriveInfoEntity) -> [String: String] {
        var dict: [String: String] = [:]
        
        let otherUsage = String((Int64(data.storageUsage) ?? 1) - (Int64(data.storageUsageInDrive) ?? 1))
        
        dict[Storage.limit.rawValue] = formatByteCount(of: data.storageLimit)
        dict[Storage.driveUsage.rawValue] = formatByteCount(of: data.storageUsageInDrive)
        dict[Storage.otherUsage.rawValue] = formatByteCount(of: otherUsage)
        dict[Storage.allUsage.rawValue] = formatByteCount(of: data.storageUsage)
        
        return dict
    }
    
    private func calculateGoogleDriveUsageRatio(usage: Double, total: Double) -> Double {
        return usage / total
    }
    
    private func formatByteCount(of usage: String) -> String {
        return ByteCountFormatter.string(fromByteCount: Int64(usage) ?? 0, countStyle: .binary)
    }
    
    private func setupUsageIndicators(data: GoogleDriveInfoEntity) {
        
        self.onlyDriveRatio = calculateGoogleDriveUsageRatio(usage: Double(data.storageUsageInDrive) ?? 1.0, total: Double(data.storageLimit) ?? 1.0)
        self.totalDriveRatio = calculateGoogleDriveUsageRatio(usage: Double(data.storageUsage) ?? 1.0, total: Double(data.storageLimit) ?? 1.0)
        
        self.googleDriveStorageUsageGraph.snp.remakeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(self.usageGraph.snp.width).multipliedBy(self.onlyDriveRatio)
            make.top.equalTo(self.storageQuotaLabel.snp.bottom).offset(6)
            make.left.equalTo(self.serviceIcon.snp.left)
        }
        
        self.totalStorageUsageGraph.snp.remakeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(self.usageGraph.snp.width).multipliedBy(self.totalDriveRatio)
            make.top.equalTo(self.storageQuotaLabel.snp.bottom).offset(6)
            make.left.equalTo(self.serviceIcon.snp.left)
        }
    }
}
