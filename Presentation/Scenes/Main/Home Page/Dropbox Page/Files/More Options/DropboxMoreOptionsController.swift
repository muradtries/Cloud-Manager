//
//  DropboxMoreOptionsController.swift
//  Presentation
//
//  Created by Murad on 23.09.22.
//

import Foundation
import UIKit
import Domain
import SnapKit

class DropboxMoreOptionsController: BaseViewController<DropboxMoreOptionsViewModel> {
    
    var pickerOptions: [Option] = []
    
    private lazy var drawer: UIView = {
        let view = UIView()
        
        self.view.addSubview(view)
        
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    private lazy var fileInfo: UIView = {
        let view = UIView()
        
        self.view.addSubview(view)
        
        view.backgroundColor = .clear
        view.addBorder(to: .bottom, color: .lightGray.withAlphaComponent(0.6), thickness: 0.7)
        
        return view
    }()
    
    private lazy var fileIcon: UIImageView = {
        let view = UIImageView()
        
        self.fileInfo.addSubview(view)
        
        return view
    }()
    
    private lazy var fileName: UILabel = {
        let view = UILabel()
        
        self.fileInfo.addSubview(view)
        
        view.textColor = .darkText
        view.font = FontFamily.Poppins.medium.font(size: 15)
        view.text = ""
        
        return view
    }()
    
    private lazy var fileLastModificationDate: UILabel = {
        let label = UILabel()
        
        self.fileInfo.addSubview(label)
        
        label.textColor = .lightGray
        label.font = FontFamily.Poppins.regular.font(size: 12)
        label.text = ""
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()

        self.view.addSubview(view)

        view.delegate = self
        view.dataSource = self
        view.register(IconLabelTableViewCell.self, forCellReuseIdentifier: "\(IconLabelTableViewCell.self)")

        view.backgroundColor = .clear
        view.separatorStyle = .singleLine
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false

        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVars()
        setupUI()
        setupCell(file: viewModel.file)
    }
    
    deinit {
        print("MORE OPTIONS VC DEALLOCATED")
    }
    
    func setupVars() {
        pickerOptions = viewModel.pickerOptions
    }
    
    override func setupUI() {
        
        view.backgroundColor = .white
        
        self.drawer.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(4)
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
        }
        
        self.fileInfo.snp.makeConstraints { make in
            make.top.equalTo(self.drawer.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.fileIcon.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.left.equalToSuperview().offset(32)
            make.centerY.equalToSuperview()
        }
        
        self.fileName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(self.fileIcon.snp.right).offset(12)
            make.right.equalToSuperview().offset(-32)
        }
        
        self.fileLastModificationDate.snp.makeConstraints { make in
            make.top.equalTo(fileName.snp.bottom).offset(4)
            make.left.equalTo(self.fileName.snp.left)
            make.right.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.fileInfo.snp.bottom)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
    }
    
    func setupCell(file: DropboxFileEntity) {
        self.fileName.text = file.name
        self.fileIcon.image = setupFileIcon(mimeType: file.mimeType)
        
        switch file.mimeType {
        case .folder:
            self.fileLastModificationDate.text = "Modified --"
        case .pdf(_), .document(_), .spreadSheet(_), .image(_), .video(_):
            self.fileLastModificationDate.text = "Modified \(file.lastModified.stringFormatted)"
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
}

extension DropboxMoreOptionsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pickerOptions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(IconLabelTableViewCell.self)") as! IconLabelTableViewCell
        cell.setupCell(icon: pickerOptions[indexPath.row].icon,
                       label: pickerOptions[indexPath.row].label)
        cell.backgroundColor = .white
        let bgColorView = UIView()
        bgColorView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch pickerOptions[indexPath.row].icon {
        case Asset.icEdit.image:
            tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true) { [weak self] in
                self?.viewModel.selectedRenama()
            }
        case Asset.icDelete.image:
            tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true) { [weak self] in
                self?.viewModel.selectedDelete()
            }
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
