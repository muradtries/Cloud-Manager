//
//  GoogleDriveController.swift
//  Presentation
//
//  Created by Murad on 30.08.22.
//

import UIKit
import SnapKit
import RxSwift
import Domain
import Photos
import PhotosUI

class GoogleDriveController: BaseViewController<GoogleDriveViewModel> {
    
    private lazy var syncFlag = true
    private lazy var compositeDisposable = CompositeDisposable()
    private lazy var disposeBag = DisposeBag()
    
    private var selectedFile: GoogleDriveFileEntity = GoogleDriveFileEntity(identifier: "",
                                                                            name: "",
                                                                            mimeType: .image(""),
                                                                            trashed: false,
                                                                            starred: false,
                                                                            shared: false,
                                                                            webContentLink: "",
                                                                            permission: .init(type: "", role: .commenter), lastModified: Date())
    private var selectedFileIndexPath: IndexPath?
    private var selectedFileIndexPathRow: Int?
    private var observable: Observable<UploadProgressEntity>?
    
    private lazy var filesAndFoldersList: [[GoogleDriveFileEntity]] = [[],[]] {
        didSet {
            DispatchQueue.main.async {
                self.itemTableView.reloadData()
            }
        }
    }

    private lazy var itemTableView: UITableView = {
        let view = UITableView()

        self.view.addSubview(view)

        view.delegate = self
        view.dataSource = self
        view.register(FileListTableViewCell.self, forCellReuseIdentifier: "\(FileListTableViewCell.self)")
        
        view.backgroundColor = .clear
        view.separatorStyle = .singleLine
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false

        return view
    }()
    
    private lazy var uploadFileButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        
        self.view.addSubview(button)
    
        button.addTarget(self, action: #selector(onUploadButton), for: .touchUpInside)
        
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .medium)
        
        button.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        button.tintColor = .systemBlue
        button.layer.cornerRadius = button.frame.width / 2
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            button.configuration = config
        }
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        syncFlag = true
        
        navigationController?.delegate = self

        viewModel.syncFiles().then { _ in
            print("🔄 Synced Files")
        }.catch { error in
            //show alert vc
            print("ERROR OCCURED WHILE SYNCING GOOGLE DRIVE FILES \(error.localizedDescription)")
        }

        let fileSubscription = viewModel.observeFiles().subscribe { received in
            if self.syncFlag {
                self.filesAndFoldersList[1] = received.event.element!
                    .sorted(by: { lhs, rhs in
                        lhs.name < rhs.name
                    })
            }
        }

        let _ = compositeDisposable.insert(fileSubscription)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        syncFlag = false
        compositeDisposable.dispose()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("😶‍🌫️ VIEW DID DISAPPEAR")
    }
    
    deinit {
        print("🗑 GOOGLE DRIVE VC IS DEALLOCATED")
    }
    
    override func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
    }

    override func setupUI() {

        view.backgroundColor = .white

        itemTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        uploadFileButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
    }
    
    @objc func onUploadButton() {
        self.viewModel.presentPickerOptions(viewController: self)
    }
    
    func uploadFile(with fileName: String, folderID: String, data: Data, mimeType: EGoogleDriveFileMimeType) {
        let (promise, observable) = viewModel.uploadFile(with: fileName, folderID: folderID, data: data, mimeType: mimeType)
        
        promise.then { _ in
            print("IMAGE UPLOADED TO GOOGLE DRIVE")
            print(self.filesAndFoldersList[0])
            self.filesAndFoldersList[0].removeFirst()
            self.viewModel.syncFiles().then {
                print("Synced Files 🔄")
            }.catch { error in
                //show alert vc
            }
        }
        
        self.observable = observable
        
        let uploadSubscription = observable.subscribe { received in
            let cell = self.itemTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FileListTableViewCell
            
            print("PROGRESS RECEIVED: \(String(describing: received.element))")
            if #available(iOS 15.0, *) {
                cell.progressView.observedProgress = received.element?.progress
            } else {
                // Fallback on earlier versions
            }
        }
        
        let _ = compositeDisposable.insert(uploadSubscription)
    }
}

extension GoogleDriveController: PickerOptionsDelegate {
    func didSelectFromPhotos() {
        print("didSelectFromPhotos")
        self.viewModel.presentImagePicker(viewController: self)
    }
    
    func didSelectFromDocuments() {
        print("didSelectFromDocuments")
        self.viewModel.presentDocumentPicker(viewController: self)
    }
}

extension GoogleDriveController: FileListTableViewCellDelegate {
    func tappedMoreButton(file: GoogleDriveFileEntity, cell: FileListTableViewCell) {
        self.selectedFile = GoogleDriveFileEntity(identifier: file.identifier,
                                                  name: file.name,
                                                  mimeType: file.mimeType,
                                                  trashed: file.trashed,
                                                  starred: file.starred,
                                                  shared: file.shared,
                                                  webContentLink: file.webContentLink,
                                                  permission: GoogleDrivePermissionEntity(type: file.permission.type, role: file.permission.role),
                                                  lastModified: file.lastModified)
        self.selectedFileIndexPathRow = itemTableView.indexPath(for: cell)?.row
        self.viewModel.presentMoreOptions(viewController: self, file: self.selectedFile)
    }
}

extension GoogleDriveController: MoreOptionsDelegate {
    
    func didSelectedRename() {
        print("didSelectRename")
        let popUpVC = RenamePopUpController()
        popUpVC.delegate = self
        popUpVC.modalPresentationStyle = .overFullScreen
        popUpVC.modalTransitionStyle = .crossDissolve
        print("SELECTED FILE NAME: \(self.selectedFile.name)")
        let isFolder = selectedFile.mimeType.toFileExtension.isEmpty ? true: false
        popUpVC.putCurrentNameIntoField(name: self.selectedFile.name, isFolder: isFolder)
        self.present(popUpVC, animated: true)
    }
    
    func didSelectedStar(starred: Bool) {
        print("didSelectedStar")
        self.viewModel.addToStarred(with: self.selectedFile.identifier, starred: starred).then { _ in
            print("FILE STAR STATUS CHANGED")
            self.itemTableView.reloadRows(at: [IndexPath(row: self.selectedFileIndexPathRow!, section: 1)], with: .none)
            self.viewModel.syncFiles().then {
                print("Synced Files 🔄")
            }.catch { error in
                //show alert vc
            }
        }
    }
    
    func didSelectedManageAccess() {
        print("didSelectManageAccess")
        viewModel.presentManageAccessVC(file: selectedFile, viewController: self)
    }
    
    func didSelectedCopyLink() {
        print("didSelectedCopyLink")
        let alert = TopPopUpAlert()
        
        if let navigationController = self.navigationController
        {
            alert.show(viewController: navigationController)
        }
        
        UIPasteboard.general.string = self.selectedFile.webContentLink
    }
    
    func didSelectedDelete() {
        let popUpVC = DeletePopUpController()
        popUpVC.delegate = self
        popUpVC.modalPresentationStyle = .overFullScreen
        popUpVC.modalTransitionStyle = .crossDissolve
        popUpVC.fileName = selectedFile.name
        self.present(popUpVC, animated: true)
    }
}

extension GoogleDriveController: RenamePopUpControllerDelegate {
    func didApprovedRenaming(to newName: String) {
        print("didApprovedRenaming")
        
        let updatedName = "\(newName)\(selectedFile.mimeType.toFileExtension)"
        
        self.viewModel.updateFileName(to: "\(updatedName)", fileID: selectedFile.identifier).then { _ in
            print("SUCCESSFULLY UPDATED NAME ✅")
            self.viewModel.syncFiles().then {
                print("Synced Files 🔄")
            }.catch { error in
                //show alert vc
            }
        }
    }
    
    func didCancelRenaming() {
        print("didCancelRenaming")
    }
}

extension GoogleDriveController: DeletePopUpControllerDelegate {
    func didCancelDeleting() {
        print("didCancelDeleting")
    }
    
    func didApprovedDeleting() {
        self.viewModel.moveToTrash(with: self.selectedFile.name, fileID: self.selectedFile.identifier)
        self.filesAndFoldersList[1].removeAll { entity in
            entity.name == self.selectedFile.name
        }
    }
}

extension GoogleDriveController: ManageAccessPopUpControllerDelegate {
    func didFinishedManagingAccess() {
        print("didFinishedEditingOptions")
        viewModel.syncFiles().then {
            print("Synced Files 🔄")
        }.catch { error in
            //show alert vc
        }
    }
}

extension GoogleDriveController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        filesAndFoldersList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filesAndFoldersList[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(FileListTableViewCell.self)", for: indexPath) as! FileListTableViewCell
            cell.setupCell(file: filesAndFoldersList[indexPath.section][indexPath.row], state: .uploading)
            cell.backgroundColor = .clear
            cell.delegate = self
            cell.isUserInteractionEnabled = false
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(FileListTableViewCell.self)", for: indexPath) as! FileListTableViewCell
            cell.setupCell(file: filesAndFoldersList[indexPath.section][indexPath.row])
            cell.backgroundColor = .clear
            cell.delegate = self
            cell.isUserInteractionEnabled = true
            let bgColorView = UIView()
            bgColorView.backgroundColor = .lightGray.withAlphaComponent(0.1)
            cell.selectedBackgroundView = bgColorView
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(FileListTableViewCell.self)") as! FileListTableViewCell
            cell.setupCell(file: filesAndFoldersList[indexPath.section][indexPath.row])
            cell.backgroundColor = .clear
            cell.delegate = self
            cell.isUserInteractionEnabled = true
            let bgColorView = UIView()
            bgColorView.backgroundColor = .lightGray.withAlphaComponent(0.1)
            cell.selectedBackgroundView = bgColorView
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.syncFlag = false
        
        switch indexPath.section {
        case 1:
            switch filesAndFoldersList[indexPath.section][indexPath.row].mimeType {
            case .folder:
                viewModel.goToFolderVC(folderID: filesAndFoldersList[indexPath.section][indexPath.row].identifier,
                                             fileName: filesAndFoldersList[indexPath.section][indexPath.row].name)
                tableView.deselectRow(at: indexPath, animated: true)
            case .image:
                viewModel.goToPreviewImage(file: filesAndFoldersList[indexPath.section][indexPath.row])
            case .pdf, .document, .spreadSheet, .video:
                tableView.deselectRow(at: indexPath, animated: true)
                viewModel.goToPreviewFileVC(file: filesAndFoldersList[indexPath.section][indexPath.row])
            }
        default:
            return
        }
    }
}

extension GoogleDriveController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        results.forEach { result in
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.item") { url, error in
                guard error == nil else {
                    print(error!)
                    return
                }
                
                guard let url = url else {
                    return
                }
                
                let dict = self.viewModel.prepareMediaForUpload(url: url)
                let fileName = dict["fileName"] as! String
                let fileExtension = dict["fileExtension"] as! String
                let imageData = dict["fileData"] as! Data
                
                let fileEntity = GoogleDriveFileEntity(identifier: "", name: fileName, mimeType: EGoogleDriveFileMimeType.image(""), trashed: false, starred: false, shared: false, webContentLink: "", permission: GoogleDrivePermissionEntity(type: "", role: .viewer), lastModified: Date())
                self.filesAndFoldersList[0].append(fileEntity)
            
                self.uploadFile(with: fileName, folderID: self.viewModel.folderID, data: imageData, mimeType: EGoogleDriveFileMimeType.image(fileExtension))
            }
        }
        
        dismiss(animated: true)
    }
}

extension GoogleDriveController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        urls.forEach { url in
            let dict = self.viewModel.prepareMediaForUpload(url: url)
            let fileName = dict["fileName"] as! String
            let fileExtension = dict["fileExtension"] as! String
            let fileData = dict["fileData"] as! Data
            
            let fileEntity = GoogleDriveFileEntity(identifier: "", name: fileName, mimeType: EGoogleDriveFileMimeType.document(".\(fileExtension)"), trashed: false, starred: false, shared: false, webContentLink: "", permission: GoogleDrivePermissionEntity(type: "", role: .viewer), lastModified: Date())
            self.filesAndFoldersList[0].append(fileEntity)
        
            self.uploadFile(with: fileName, folderID: self.viewModel.folderID, data: fileData, mimeType: EGoogleDriveFileMimeType.document(fileExtension))
        }
        dismiss(animated: true)
    }
}

extension GoogleDriveController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("DID SHOW \(viewController) VC")
        print("VIEW CONTROLLERS LIST : \(navigationController.viewControllers)")
    }
}
