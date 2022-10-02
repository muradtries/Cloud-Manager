//
//  IconLabelTableViewCell.swift
//  Presentation
//
//  Created by Murad on 15.09.22.
//

import Foundation
import SnapKit

class IconLabelTableViewCell: UITableViewCell {
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        
        self.contentView.addSubview(view)
        
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.textColor = .darkText
        label.font = FontFamily.Poppins.regular.font(size: 14)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(icon: UIImage, label: String) {
        self.icon.image = icon
        if icon == Asset.icStarFilled.image {
            self.icon.tintColor = .systemYellow
        } else if icon == Asset.icDelete.image {
            self.icon.tintColor = .systemRed
            self.label.textColor = .systemRed
        } else {
            self.icon.tintColor = .darkGray
        }
        self.label.text = label
    }
    
    private func setupCell() {
        
        self.icon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(self.icon.snp.right).offset(12)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
    }
}
