//
//  Dropbox Page.swift
//  Presentation
//
//  Created by M/D Student - Murad A. on 21.09.22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Domain
import Photos
import PhotosUI

class DropboxController: BaseViewController<DropboxViewModel> {
    
    private lazy var syncFlag = true
    private lazy var compositeDisposable = CompositeDisposable()
    private lazy var disposeBag = DisposeBag()
    
    private var selectedFile: DropboxFileEntity = DropboxFileEntity(identifier: "",
                                                                    parentFolderPath: "",
                                                                    name: "",
                                                                    lastModified: Date(),
                                                                    path: "",
                                                                    mimeType: .image(""))
    private var selectedFileIndexPathRow: Int?
    private var observable: Observable<UploadProgressEntity>?
    
    private lazy var filesAndFoldersList: [[DropboxFileEntity]] = [[],[]] {
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
        view.register(DropboxFileListTableViewCell.self, forCellReuseIdentifier: "\(DropboxFileListTableViewCell.self)")
        
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
            // show alert vc
            print("ERROR OCCURED WHILE SYNCING DROPBOX FILES \(error.localizedDescription)")
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
        print("🗑 DROPBOX VC IS DEALLOCATED")
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
    
    func uploadFile(to folderPath: String, with fileName: String, data: Data) {
        let (promise, observable) = viewModel.uploadFile(to: folderPath, with: fileName, data: data)
        promise.then { _ in
            print("IMAGE UPLOADED TO GOOGLE DRIVE")
            print(self.filesAndFoldersList[0])
            self.filesAndFoldersList[0].removeFirst()
            self.viewModel.syncFiles().then { _ in
                print("🔄 Synced Files")
            }
        }
        
        self.observable = observable
        
        let uploadSubscription = observable.subscribe { received in
            let cell = self.itemTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! DropboxFileListTableViewCell
            if #available(iOS 15.0, *) {
                cell.progressView.observedProgress = received.element?.progress
            } else {
                // Fallback on earlier versions
            }
        }

        let _ = compositeDisposable.insert(uploadSubscription)
    }
}

extension DropboxController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filesAndFoldersList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filesAndFoldersList[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DropboxFileListTableViewCell.self)") as! DropboxFileListTableViewCell
            cell.setupCell(file: filesAndFoldersList[indexPath.section][indexPath.row], state: .uploading)
            cell.delegate = self
            cell.isUserInteractionEnabled = false
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DropboxFileListTableViewCell.self)") as! DropboxFileListTableViewCell
            cell.setupCell(file: filesAndFoldersList[indexPath.section][indexPath.row])
            cell.delegate = self
            cell.isUserInteractionEnabled = true
            let bgColorView = UIView()
            bgColorView.backgroundColor = .lightGray.withAlphaComponent(0.1)
            cell.selectedBackgroundView = bgColorView
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DropboxFileListTableViewCell.self)") as! DropboxFileListTableViewCell
            cell.setupCell(file: filesAndFoldersList[indexPath.section][indexPath.row])
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
        switch filesAndFoldersList[1][indexPath.row].mimeType {
        case .folder:
            viewModel.goToFolderVC(fileID: filesAndFoldersList[indexPath.section][indexPath.row].path,
                                   fileName: filesAndFoldersList[indexPath.section][indexPath.row].name)
            tableView.deselectRow(at: indexPath, animated: true)
        case .image:
            viewModel.goToPreviewImage(file: filesAndFoldersList[indexPath.section][indexPath.row])
        case .pdf, .document, .spreadSheet, .video:
            tableView.deselectRow(at: indexPath, animated: true)
            viewModel.goToPreviewFileVC(file: filesAndFoldersList[1][indexPath.row])
        }
    }
}

extension DropboxController: PickerOptionsDelegate {
    func didSelectFromPhotos() {
        print("didSelectFromPhotos")
        self.viewModel.presentImagePicker(viewController: self)
    }
    
    func didSelectFromDocuments() {
        print("didSelectFromDocuments")
        self.viewModel.presentDocumentPicker(viewController: self)
    }
}

extension DropboxController: DropboxFileListTableViewCellDelegate {
    
    func tappedMoreButton(file: DropboxFileEntity, cell: DropboxFileListTableViewCell) {
        self.selectedFile = DropboxFileEntity(identifier: file.identifier,
                                              parentFolderPath: file.parentFolderPath,
                                              name: file.name,
                                              lastModified: file.lastModified,
                                              path: file.path,
                                              mimeType: file.mimeType)
        self.selectedFileIndexPathRow = itemTableView.indexPath(for: cell)?.row
        self.viewModel.presentMoreOptions(viewController: self, file: self.selectedFile)
    }
}

extension DropboxController: DropboxMoreOptionsDelegate {
    func didSelectedRename() {
        print("didSelectedRename")
        let popUpVC = RenamePopUpController()
        popUpVC.delegate = self
        popUpVC.modalPresentationStyle = .overFullScreen
        popUpVC.modalTransitionStyle = .crossDissolve
        let isFolder = selectedFile.mimeType.toFileExtension.isEmpty ? true : false
        popUpVC.putCurrentNameIntoField(name: self.selectedFile.name, isFolder: isFolder)
        self.present(popUpVC, animated: true)
    }
    
    func didSelectedDelete() {
        print("didSelectedDelete")
        let popUpVC = DeletePopUpController()
        popUpVC.delegate = self
        popUpVC.modalPresentationStyle = .overFullScreen
        popUpVC.modalTransitionStyle = .crossDissolve
        popUpVC.fileName = selectedFile.name
        self.present(popUpVC, animated: true)
    }
}

extension DropboxController: DeletePopUpControllerDelegate {
    func didCancelDeleting() {
        print("didCancelDeleting")
    }
    
    func didApprovedDeleting() {
        self.viewModel.moveToTrash(path: self.selectedFile.path)
        self.filesAndFoldersList[1].removeAll { entity in
            entity.name == self.selectedFile.name
        }
    }
}

extension DropboxController: RenamePopUpControllerDelegate {
    func didCancelRenaming() {
        print("didCancelRenaming")
    }
    
    func didApprovedRenaming(to newName: String) {
        print("didApprovedRenaming")
        
        let updatedName = "\(newName)\(selectedFile.mimeType.toFileExtension)"
        
        self.viewModel.updateFileName(from: self.selectedFile.name, to: updatedName, parentFolderPath: viewModel.folderPath).then { _ in
            print("✅ SUCCESSFULLY UPDATED NAME")
            self.viewModel.syncFiles().then { _ in
                print("Synced Files 🔄")
            }
        }
    }
}

extension DropboxController: PHPickerViewControllerDelegate {
    
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

                let fileEntity = DropboxFileEntity(identifier: "",
                                                   parentFolderPath: "",
                                                   name: fileName,
                                                   lastModified: Date(),
                                                   path: "",
                                                   mimeType: EDropboxFileMimeType.image(".\(fileExtension)"))
                self.filesAndFoldersList[0].append(fileEntity)

                self.uploadFile(to: self.viewModel.folderPath, with: fileName, data: imageData)
            }
        }
        
        dismiss(animated: true)
    }
}

extension DropboxController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        urls.forEach { url in
            let dict = self.viewModel.prepareMediaForUpload(url: url)
            let fileName = dict["fileName"] as! String
            let fileExtension = dict["fileExtension"] as! String
            let fileData = dict["fileData"] as! Data
            
            let fileEntity = DropboxFileEntity(identifier: "",
                                               parentFolderPath: "",
                                               name: fileName,
                                               lastModified: Date(),
                                               path: "",
                                               mimeType: EDropboxFileMimeType.document(".\(fileExtension)"))
            self.filesAndFoldersList[0].append(fileEntity)
            
            self.uploadFile(to: self.viewModel.folderPath, with: fileName, data: fileData)
        }
        dismiss(animated: true)
    }
}

extension DropboxController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("DID SHOW \(viewController) VC")
        print("VIEW CONTROLLERS LIST : \(navigationController.viewControllers)")
    }
}
