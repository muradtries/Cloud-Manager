//
//  HomePageController.swift
//  Presentation
//
//  Created by Murad on 30.08.22.
//

import UIKit
import RxSwift
import SnapKit
import RxRelay 
import RxCocoa

class HomePageController: BaseViewController<HomePageViewModel> {
    
    let notificationCenter = NotificationCenter.default
    
    private lazy var compositeDisposable = CompositeDisposable()
    private var disposeBag: DisposeBag?
    
    var numberOfConnectedServices: Int = 0 {
        didSet {
            if self.infoStackView.subviews.count > 0 {
                self.disclaimerStackView.isHidden = true
                self.disclaimerImage.removeFromSuperview()
                self.disclaimerText.removeFromSuperview()
            } else {
                self.disclaimerStackView.isHidden = false
                self.disclaimerStackView.addArrangedSubview(self.disclaimerImage)
                self.disclaimerStackView.addArrangedSubview(self.disclaimerText)
            }
        }
    }
    
    private lazy var disclaimerStackView: UIStackView = {
        let view = UIStackView()
        
        self.view.addSubview(view)
        
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 0
        
        return view
    }()
    
    private lazy var disclaimerImage: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        view.image = Asset.Media.comingSoon.image.resizedImage(size: CGSize(width: 300, height: 300))
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var disclaimerText: UILabel = {
        let label = UILabel()
        
        label.font = FontFamily.Poppins.regular.font(size: 16)
        label.textColor = .darkText
        
        let imageAttachment = NSTextAttachment(image: (Asset.Icons.icHub.image.resizedImage(size: CGSize(width: 15, height: 15))?.withTintColor(.systemBlue))!)
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        
        let completeText = NSMutableAttributedString(string: "Tap the ")
        
        completeText.append(attachmentString)
        
        let textAfterIcon = NSAttributedString(string: " icon to add cloud services")
        
        completeText.append(textAfterIcon)
        
        label.textAlignment = .center
        label.attributedText = completeText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private lazy var infoScrollView: UIScrollView = {
        let view = UIScrollView()
        
        self.view.addSubview(view)
        
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    private lazy var infoStackView: UIStackView = {
        let view = UIStackView()
        
        self.infoScrollView.addSubview(view)
        
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 24
        
        return view
    }()
    
    private lazy var googleDriveInfo: GoogleDriveInfoView = {
        let view = GoogleDriveInfoView()
        
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var dropboxInfo: DropboxInfoView = {
        let view = DropboxInfoView()
        
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavBar()
        
        let tapGestureRecognizerDrive = UITapGestureRecognizer.init(target: self, action: #selector(onTapGoogleDriveInfo(_:)))
        let tapGestureRecognizerDropbox = UITapGestureRecognizer.init(target: self, action: #selector(onTapGoogleDropboxInfo(_:)))
        self.googleDriveInfo.addGestureRecognizer(tapGestureRecognizerDrive)
        self.dropboxInfo.addGestureRecognizer(tapGestureRecognizerDropbox)
        
        notificationCenter.addObserver(self, selector: #selector(connectedGoogleDrive), name: Notification.Name("ConnectedGoogleDrive"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(disconnectedGoogleDrive), name: Notification.Name("DisconnectedGoogleDrive"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(connectedDropbox), name: Notification.Name("ConnectedDropbox"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(disconnectedDropbox), name: Notification.Name("DisconnectedDropbox"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.disposeBag = DisposeBag()
        
        guard let disposeBag = self.disposeBag else { return }
        
        if UserDefaults.standard.bool(forKey: "connectedGoogleDrive") {
            self.viewModel.restoreUser().then { _ in
                print("Restored User")
                self.viewModel.syncGoogleDriveInfo()
            }
            
            self.viewModel.observeGoogleDriveInfo()
                .subscribe { info in
                    print("🧐 observeGoogleDriveInfo called")
                    self.googleDriveInfo.fillInfoView(with: info)
                } onError: { error in
                    print(NSError(domain: "Google Drive Info Subscription", code: 1))
                } onDisposed: {
                    print("☠️ Google Drive Info Subscription DISPOSED")
                }.disposed(by: disposeBag)
        }
        
        if UserDefaults.standard.bool(forKey: "connectedDropbox") {
            self.viewModel.syncDropboxInfo()
            
            self.viewModel.observeDropboxInfo()
                .subscribe { info in
                    print("🧐 observeDropboxInfo called")
                    self.dropboxInfo.fillInfoView(with: info)
                } onError: { error in
                    print(NSError(domain: "infoSubscription", code: 1))
                } onDisposed: {
                    print("☠️ Dropbox Info Subscription DISPOSED")
                }.disposed(by: disposeBag)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disposeBag = nil
    }
    
    deinit {
        print("HOME PAGE VC IS DEALLOCATED")
    }
    
    override func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: FontFamily.Poppins.medium.font(size: 32),
                                                                        NSAttributedString.Key.foregroundColor:
                                                                            UIColor.darkText]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: FontFamily.Poppins.medium.font(size: 18),
                                                                        NSAttributedString.Key.foregroundColor:
                                                                            UIColor.darkText]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Asset.Icons.icHub.image.resizedImage(size: CGSize(width: 28, height: 28)), style: .plain, target: self, action: #selector(onTapAddButton))
    }
    
    override func setupUI() {
        
        self.view.backgroundColor = .white
        
        self.title = "Home"
        
        if self.infoStackView.subviews.count > 0 {
            self.disclaimerStackView.isHidden = true
            self.disclaimerImage.removeFromSuperview()
            self.disclaimerText.removeFromSuperview()
        } else {
            self.disclaimerStackView.isHidden = false
            self.disclaimerStackView.addArrangedSubview(self.disclaimerImage)
            self.disclaimerStackView.addArrangedSubview(self.disclaimerText)
        }
        
        if UserDefaults.standard.bool(forKey: "connectedGoogleDrive") {
            self.infoStackView.addArrangedSubview(self.googleDriveInfo)
        }

        if UserDefaults.standard.bool(forKey: "connectedDropbox") {
            self.infoStackView.addArrangedSubview(self.dropboxInfo)
        }
        
        self.disclaimerStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
        }
        
        self.infoScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }

        self.infoStackView.snp.makeConstraints { make in
            make.left.equalTo(self.infoScrollView.contentLayoutGuide.snp.left)
            make.top.equalTo(self.infoScrollView.contentLayoutGuide.snp.top)
            make.centerX.equalTo(self.infoScrollView.snp.centerX)
            make.bottom.equalTo(self.infoScrollView.contentLayoutGuide.snp.bottom)
        }
    }
    
    @objc func onTapGoogleDriveInfo(_ sender: UITapGestureRecognizer? = nil) {
        self.viewModel.goToGoogleDriveController()
    }
    
    @objc func onTapGoogleDropboxInfo(_ sender: UITapGestureRecognizer? = nil) {
        self.viewModel.goToDropboxController()
    }
    
    @objc func connectedGoogleDrive() {
        self.infoStackView.addArrangedSubview(self.googleDriveInfo)
        self.numberOfConnectedServices += 1
        self.logNumberOfConnectedServices()
    }
    
    @objc func disconnectedGoogleDrive() {
        self.googleDriveInfo.removeFromSuperview()
        self.numberOfConnectedServices -= 1
        self.logNumberOfConnectedServices()
    }
    
    @objc func connectedDropbox() {
        self.infoStackView.addArrangedSubview(self.dropboxInfo)
        self.numberOfConnectedServices += 1
        self.logNumberOfConnectedServices()
    }
    
    @objc func disconnectedDropbox() {
        self.dropboxInfo.removeFromSuperview()
        self.numberOfConnectedServices -= 1
        self.logNumberOfConnectedServices()
    }
    
    @objc func onTapAddButton() {
        self.viewModel.presentCloudServices(viewController: self)
    }
}

extension HomePageController: ConnectServicesDelegate {
    func requestedToConnectToGoogleDrive() {
        self.viewModel.connectToGoogleDrive(presenting: self)
        print("requestedToConnectToGoogleDrive")
    }
    
    func requestedToConnectToDropbox() {
        self.viewModel.connectToDropbox(presenting: self)
        print("requestedToConnectToDropbox")
    }
    
    func requestedToDisconnectGoogleDrive() {
        self.viewModel.disconnectGoogleDrive()
        print("requestedToDisconnectGoogleDrive")
    }
    
    func requestedToDisconnectDropbox() {
        self.viewModel.disconnectDropbox()
        print("requestedToDisconnectDropbox")
    }
}

extension HomePageController {
    func logNumberOfConnectedServices() {
        print("Number of connected services: \(self.numberOfConnectedServices)")
    }
}
