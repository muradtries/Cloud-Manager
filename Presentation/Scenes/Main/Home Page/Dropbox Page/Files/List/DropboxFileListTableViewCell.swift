//
//  DropboxFileListTableViewCell.swift
//  Presentation
//
//  Created by Murad on 22.09.22.
//

import Foundation
import Domain
import RxSwift
import SnapKit

enum FileState {
    case normal
    case uploading
}

protocol DropboxFileListTableViewCellDelegate: AnyObject {
    func tappedMoreButton(file: DropboxFileEntity, cell: DropboxFileListTableViewCell)
}

class DropboxFileListTableViewCell: UITableViewCell {
    
    weak var delegate: DropboxFileListTableViewCellDelegate?
    
    var fileID: String = ""
    var file: DropboxFileEntity?
    
    private lazy var fileIcon: UIImageView = {
        let view = UIImageView()
        
        self.contentView.addSubview(view)
        
        view.image = UIImage()
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        
        self.contentView.addSubview(view)
        
        view.distribution = .equalSpacing
        view.alignment = .leading
        view.axis = .vertical
        view.spacing = 4
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
        
        return view
    }()
    
    private lazy var fileName: UILabel = {
        let label = UILabel()
        
//        self.contentView.addSubview(label)
        
        label.font = FontFamily.Poppins.regular.font(size: 16)
        label.textColor = .black
        
        return label
    }()
    
    lazy var fileLastModificationDate: UILabel = {
        let label = UILabel()
        
        label.font = FontFamily.Poppins.regular.font(size: 12)
        label.textColor = .lightGray
        
        label.text = "Modified 01 Jan 1111"
        
        return label
    }()
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView(frame: CGRect(x: 0, y: 0, width: 128, height: 4))
        
//        self.contentView.addSubview(view)
        
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.progressTintColor = .systemBlue
        view.progressViewStyle = .bar
        view.progress = 0.0
        
        return view
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        
        self.contentView.addSubview(button)
        
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.setImage(UIImage(systemName: "ellipsis"), for: .selected)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(onMoreButton), for: .touchUpInside)
        
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(file: DropboxFileEntity, state: FileState = .normal) {
        self.fileName.text = file.name
        self.fileIcon.image = setupFileIcon(mimeType: file.mimeType)
        self.fileID = file.identifier
        self.file = file
        
        switch file.mimeType {
        case .folder:
            self.fileLastModificationDate.text = "--"
        case .pdf(_), .document(_), .spreadSheet(_), .image(_), .video(_):
            self.fileLastModificationDate.text = "Modified \(file.lastModified.stringFormatted)"
        }
        
        switch state {
        case .normal:
            self.fileIcon.alpha = 1.0
            self.fileName.alpha = 1.0
            self.fileLastModificationDate.alpha = 1.0
            self.progressView.removeFromSuperview()
        case .uploading:
            self.fileIcon.alpha = 0.5
            self.fileName.alpha = 0.5
            self.fileLastModificationDate.alpha = 0.5
            self.progressView.alpha = 1.0
            self.stackView.addArrangedSubview(self.progressView)
        }
    }
    
    private func setupCellConstraints() {
        self.backgroundColor = .clear
        
        self.stackView.addArrangedSubview(self.fileName)
        self.stackView.addArrangedSubview(self.fileLastModificationDate)
        self.stackView.addArrangedSubview(self.progressView)
        
        self.fileIcon.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(self.fileIcon.snp.right).offset(12)
            make.right.equalTo(self.moreButton.snp.left).offset(-4)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        self.progressView.snp.makeConstraints { make in
            make.height.equalTo(2.5)
            make.width.equalTo(196)
        }
        
        self.moreButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupFileIcon(mimeType: EDropboxFileMimeType) -> UIImage {
        switch mimeType {
        case .folder:
            self.fileIcon.tintColor = .lightGray
            return Asset.icFolder.image
        case .pdf:
            self.fileIcon.tintColor = .systemRed
            return Asset.icFile.image
        case .document:
            self.fileIcon.tintColor = .systemBlue
            return Asset.icDocument.image
        case .spreadSheet:
            self.fileIcon.tintColor = .systemGreen
            return Asset.icSpreadsheet.image
        case .image:
            self.fileIcon.tintColor = .systemPurple
            return Asset.icImage.image
        case .video:
            self.fileIcon.tintColor = .systemOrange
            return Asset.icVideo.image
        }
    }
    
    @objc func onMoreButton() {
        print("MORE BUTTON TAPPED")
        delegate?.tappedMoreButton(file: file!, cell: self)
    }
}
