//
//  SplashController.swift
//  Presentation
//
//  Created by Murad on 05.10.22.
//

import Foundation
import SnapKit

public class SplashController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 99, height: 128))
        
        self.view.addSubview(view)
        
        view.image = Asset.Icons.cloud.image.withTintColor(.white)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var logoIsHidden: Bool = false
    
    static let logoImageBig: UIImage = Asset.Icons.cloud.image
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        self.view.backgroundColor = .systemBlue
        
        self.imageView.isHidden = self.logoIsHidden
        
        self.imageView.snp.makeConstraints { make in
            make.width.equalTo(99)
            make.height.equalTo(128)
            make.center.equalToSuperview()
        }
    }
}
