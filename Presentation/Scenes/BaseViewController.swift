//
//  BaseViewController.swift
//  Presentation
//
//  Created by Murad on 01.09.22.
//

import UIKit

public class BaseViewController<VM: AnyObject>: UIViewController {
    internal var viewModel: VM
    
    init(vm: VM) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        setupUI()
        setupNavBar()
    }
    
    func setupUI() {
    }
    
    func setupNavBar() {
    }
}
