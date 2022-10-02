//
//  PickerOptionsController.swift
//  Presentation
//
//  Created by M/D Student - Murad A. on 13.09.22.
//

import Foundation
import UIKit
import SnapKit

class PickerOptionsController: BaseViewController<PickerOptionsViewModel> {
    
    var pickerOptions: [Option] = []
    
    private lazy var drawer: UIView = {
        let view = UIView()
        
        self.view.addSubview(view)
        
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        self.view.addSubview(label)
        
        label.text = "Upload from:"
        label.font = FontFamily.Poppins.regular.font(size: 18)
        label.textColor = .darkText
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()

        self.view.addSubview(view)

        view.delegate = self
        view.dataSource = self
        view.register(IconLabelTableViewCell.self, forCellReuseIdentifier: "\(IconLabelTableViewCell.self)")

        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false

        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVars()
        setupUI()
    }
    
    deinit {
        print("PICKER OPTIONS VC DEALLOCATED")
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
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.drawer.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
    }
}

extension PickerOptionsController: UITableViewDelegate, UITableViewDataSource {
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
        switch pickerOptions[indexPath.row].label {
        case "Photos Library":
            tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true) { [weak self] in
                self?.viewModel.selectedPhotos()
            }
        case "Documents":
            tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true) { [weak self] in
                self?.viewModel.selectedDocuments()
            }
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
