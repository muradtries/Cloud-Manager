//
//  TopPopUpAlert.swift
//  Presentation
//
//  Created by Murad on 18.09.22.
//

import Foundation
import SnapKit

enum PopUpType {
    case copy
    case starred
    case movedToTrash
}

class TopPopUpAlert: UIView {
    private lazy var contentView: UIView = {
        let view = UIView()
        
        view.alpha = 0
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        
        self.contentView.addSubview(view)
        
        view.image = Asset.Icons.icCopy.image
        view.tintColor = .white
        
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.text = "Copied link to clipboard"
        label.font = FontFamily.Poppins.regular.font(size: 14)
        label.textColor = .white
        
        return label
    }()
    
    private func setupView() {
        
        self.icon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.equalToSuperview().offset(12)
            make.centerY.equalTo(self.descriptionLabel.snp.centerY)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalTo(self.icon.snp.right).offset(4)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    func setupPopUp(with icon: UIImage, descriptionText: String, backgroundColor: UIColor) {
        self.icon.image = icon
        self.descriptionLabel.text = descriptionText
        self.contentView.backgroundColor = backgroundColor
    }
    
    func show(viewController: UIViewController) {
        guard let targetView = viewController.view else { return }
        
        contentView.frame = CGRect(x: 20, y: 32, width: targetView.frame.width - 40, height: 40)
        targetView.addSubview(contentView)
        
        setupView()
        
        UIView.transition(with: self.contentView, duration: 0.1,
                          options: .curveEaseIn,
                          animations: {
            self.contentView.alpha = 1
            self.contentView.center.y += 25
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveEaseOut) {
                self.contentView.alpha = 0
                self.contentView.center.y -= 25
            } completion: { finished in
                self.contentView.removeFromSuperview()
            }
        }
    }
    
    deinit {
        print("BOTTOM POP UP ALERT DEALLOCATED")
    }
}
