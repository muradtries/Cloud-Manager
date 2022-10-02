//
//  HomePageCoordinator.swift
//  Presentation
//
//  Created by Murad on 31.08.22.
//

import Foundation
import UIKit
import Domain
import Swinject
import Photos
import PhotosUI

public class HomePageCoordinator: Coordinator {
    weak public var parentCoordinator: Coordinator?
    
    public var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    private var resolver: Resolver
    
    init(navigationController: UINavigationController,
         resolver: Resolver) {
        print("HOME PAGE COORDINATOR INITIALIZED")
        
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.navigationBar.barTintColor = .white
        self.navigationController.navigationBar.tintColor = .systemBlue
        self.navigationController.customizeBackButton()
        
        self.resolver = resolver
    }
    
    deinit {
        print("HOME PAGE COORDINATOR DEALLOCATED")
    }
    
    public func start() {
        initializeHomeVC()
    }
    
    func initializeHomeVC() {
        let homeVC = HomePageController(vm: resolver.resolve(HomePageViewModel.self)!)
        homeVC.viewModel.presentationDelegate = self
        homeVC.viewModel.navigationDelegate = self
        
        let tabBarItem = UITabBarItem(title: "Home", image: Asset.icHome.image, tag: 1)
        homeVC.tabBarItem = tabBarItem
        
        self.navigationController.pushViewController(homeVC, animated: true)
    }
}

extension HomePageCoordinator: HomePageNavigationDelegate {
    
    func goToGoogleDriveController() {
        let googleDriveVC = GoogleDriveController(vm: GoogleDriveViewModel(
                observeGoogleDriveFilesUseCase: resolver.resolve(ObserveGoogleDriveFilesUseCase.self)!,
                syncGoogleDriveFilesUseCase: resolver.resolve(SyncGoogleDriveFilesUseCase.self)!,
                downloadFileUseCase: resolver.resolve(DownloadGoogleDriveFileUseCase.self)!,
                uploadFileUseCase: resolver.resolve(UploadGoogleDriveFileUseCase.self)!,
                updateFileNameUseCase: resolver.resolve(UpdateFileNameUseCase.self)!,
                moveToTrashUseCase: resolver.resolve(MoveToTrashUseCase.self)!,
                addToStarredUseCase: resolver.resolve(AddToStarredUseCase.self)!,
                folderID: "root"))
        googleDriveVC.title = "Google Drive"
        googleDriveVC.viewModel.presentationDelegate = self
        googleDriveVC.viewModel.navigationDelegate = self
        self.navigationController.pushViewController(googleDriveVC, animated: true)
    }
    
    func goToDropboxController() {
        let dropboxVC = DropboxController(vm: DropboxViewModel(
            syncDropboxFilesUseCase: resolver.resolve(SyncDropboxFilesUseCase.self)!,
            observeDropboxFileUseCase: resolver.resolve(ObserveDropboxFilesUseCase.self)!,
            downloadFileUseCase: resolver.resolve(DownloadDropboxFileUseCase.self)!,
            uploadFileUseCase: resolver.resolve(UploadDropboxFileUseCase.self)!,
            updateFileNameUseCase: resolver.resolve(UpdateDropboxFileNameUseCase.self)!,
            moveToTrashUseCase: resolver.resolve(MoveToTrashDropboxFileUseCase.self)!,
            folderPath: ""))
        dropboxVC.title = "Dropbox"
        dropboxVC.viewModel.navigationDelegate = self
        dropboxVC.viewModel.presentationDelegate = self
        self.navigationController.pushViewController(dropboxVC, animated: true)
    }
}

extension HomePageCoordinator: HomePagePresentationDelegate {
    func presentCloudServices(viewController: HomePageController) {
        let vc = ConnectServicesController()
        vc.delegate = viewController
        if #available(iOS 15.0, *) {
            let detent: UISheetPresentationController.Detent = ._detent(withIdentifier: "Smallest", constant: 150.0)
            vc.sheetPresentationController?.detents = [detent]
        } else {
            viewController.present(vc, animated: true)
        }
        viewController.present(vc, animated: true)
    }
}

extension HomePageCoordinator: GoogleDriveNavigationDelegate {
    
    func goToFolderVC(folderID: String, folderName: String) {
        let googleDriveVC = GoogleDriveController(
            vm: GoogleDriveViewModel(
                observeGoogleDriveFilesUseCase: resolver.resolve(ObserveGoogleDriveFilesUseCase.self)!,
                syncGoogleDriveFilesUseCase: resolver.resolve(SyncGoogleDriveFilesUseCase.self)!,
                downloadFileUseCase: resolver.resolve(DownloadGoogleDriveFileUseCase.self)!,
                uploadFileUseCase: resolver.resolve(UploadGoogleDriveFileUseCase.self)!,
                updateFileNameUseCase: resolver.resolve(UpdateFileNameUseCase.self)!,
                moveToTrashUseCase: resolver.resolve(MoveToTrashUseCase.self)!,
                addToStarredUseCase: resolver.resolve(AddToStarredUseCase.self)!,
                folderID: folderID
            )
        )
        googleDriveVC.title = folderName
        googleDriveVC.viewModel.presentationDelegate = self
        googleDriveVC.viewModel.navigationDelegate = self
        navigationController.pushViewController(googleDriveVC, animated: true)
    }
    
    func goToPreviewFileVC(file: GoogleDriveFileEntity) {
        let previewFileVC = PreviewFileController(vm: PreviewFileViewModel(downloadFileUseCase: resolver.resolve(DownloadGoogleDriveFileUseCase.self)!, file: file))
        previewFileVC.title = file.name.pathPrefix
        previewFileVC.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(previewFileVC, animated: true)
    }
    
    func goToPreviewImage(file: GoogleDriveFileEntity) {
        let previewFileVC = PreviewImageController(vm: PreviewFileViewModel(downloadFileUseCase: resolver.resolve(DownloadGoogleDriveFileUseCase.self)!, file: file))
        previewFileVC.title = file.name.pathPrefix
        previewFileVC.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(previewFileVC, animated: true)
    }
}

extension HomePageCoordinator: DropboxNavigationDelegate {
    
    func goToDropboxFolderVC(folderPath: String, folderName: String) {
        let dropboxVC = DropboxController(vm: DropboxViewModel(syncDropboxFilesUseCase: resolver.resolve(SyncDropboxFilesUseCase.self)!,observeDropboxFileUseCase: resolver.resolve(ObserveDropboxFilesUseCase.self)!, downloadFileUseCase: resolver.resolve(DownloadDropboxFileUseCase.self)!, uploadFileUseCase: resolver.resolve(UploadDropboxFileUseCase.self)!,updateFileNameUseCase: resolver.resolve(UpdateDropboxFileNameUseCase.self)!, moveToTrashUseCase: resolver.resolve(MoveToTrashDropboxFileUseCase.self)!,
            folderPath: folderPath))
        dropboxVC.title = folderName
        dropboxVC.viewModel.navigationDelegate = self
        dropboxVC.viewModel.presentationDelegate = self
        self.navigationController.pushViewController(dropboxVC, animated: true)
    }
    
    func goToPreviewFileVC(file: DropboxFileEntity) {
        let previewFileVC = DropboxPreviewFileController(vm: DropboxPreviewFileViewModel(downloadFileUseCase: resolver.resolve(DownloadDropboxFileUseCase.self)!, file: file))
        previewFileVC.title = file.name.pathPrefix
        previewFileVC.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(previewFileVC, animated: true)
    }
    
    func goToPreviewImage(file: DropboxFileEntity) {
        let previewFileVC = DropboxPreviewImageController(vm: DropboxPreviewFileViewModel(downloadFileUseCase: resolver.resolve(DownloadDropboxFileUseCase.self)!, file: file))
        previewFileVC.title = file.name.pathPrefix
        previewFileVC.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(previewFileVC, animated: true)
    }
}

extension HomePageCoordinator: GoogleDrivePresentationDelegate {
    func presentManageAccessVC(file: GoogleDriveFileEntity, viewController: GoogleDriveController) {
        let popUpVC = ManageAccessPopUpController(vm: ManageAccessViewModel(file: file, manageAccessToFileUseCase: resolver.resolve(ManageAccessToFileUseCase.self)!, removeAccessToFileUseCase: resolver.resolve(RemoveAccessToFileUseCase.self)!))
        popUpVC.viewModel.delegate = viewController
        popUpVC.modalPresentationStyle = .overFullScreen
        popUpVC.modalTransitionStyle = .crossDissolve
        viewController.present(popUpVC, animated: true)
    }
    

    func presentPickerOptions(viewController: GoogleDriveController) {
        let pickerOptionsVC = PickerOptionsController(vm: PickerOptionsViewModel())
        pickerOptionsVC.viewModel.delegate = viewController
        pickerOptionsVC.modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            let detent: UISheetPresentationController.Detent = ._detent(withIdentifier: "Smallest", constant: 170.0)
            pickerOptionsVC.sheetPresentationController?.detents = [detent]
        } else {
            viewController.present(pickerOptionsVC, animated: true)
        }
        
        viewController.present(pickerOptionsVC, animated: true)
    }
    
    func presentImagePicker(viewController: GoogleDriveController) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = viewController
        viewController.present(picker, animated: true)
    }
    
    func presentDocumentPicker(viewController: GoogleDriveController) {
        let picker = UIDocumentPickerViewController.init(forOpeningContentTypes: [.text, .image, .data, .video])
        picker.delegate = viewController
        viewController.present(picker, animated: true)
    }
    
    func presentMoreOptions(viewController: GoogleDriveController, file: GoogleDriveFileEntity) {
        let moreOptionsVC = MoreOptionsController(vm: MoreOptionsViewModel(delegate: viewController, file: file))
        moreOptionsVC.view.backgroundColor = .white
        moreOptionsVC.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            let detent: UISheetPresentationController.Detent = ._detent(withIdentifier: "Smallest", constant: 320.0)
            moreOptionsVC.sheetPresentationController?.detents = [detent]
        } else {
            viewController.present(moreOptionsVC, animated: true)
        }
        viewController.present(moreOptionsVC, animated: true)
    }
}

extension HomePageCoordinator: DropboxPresentationDelegate {
    func presentPickerOptions(viewController: DropboxController) {
        let pickerOptionsVC = PickerOptionsController(vm: PickerOptionsViewModel())
        pickerOptionsVC.viewModel.delegate = viewController
        pickerOptionsVC.modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            let detent: UISheetPresentationController.Detent = ._detent(withIdentifier: "Smallest", constant: 170.0)
            pickerOptionsVC.sheetPresentationController?.detents = [detent]
        } else {
            viewController.present(pickerOptionsVC, animated: true)
        }
        
        viewController.present(pickerOptionsVC, animated: true)
    }
    
    func presentImagePicker(viewController: DropboxController) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = viewController
        viewController.present(picker, animated: true)
    }

    func presentDocumentPicker(viewController: DropboxController) {
        let picker = UIDocumentPickerViewController.init(forOpeningContentTypes: [.text, .image, .data, .video])
        picker.delegate = viewController
        viewController.present(picker, animated: true)
    }

    func presentMoreOptions(viewController: DropboxController, file: DropboxFileEntity) {
        let moreOptionsVC = DropboxMoreOptionsController(vm: DropboxMoreOptionsViewModel(delegate: viewController, file: file))
        moreOptionsVC.view.backgroundColor = .white
        moreOptionsVC.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            let detent: UISheetPresentationController.Detent = ._detent(withIdentifier: "Smallest", constant: 180.0)
            moreOptionsVC.sheetPresentationController?.detents = [detent]
        } else {
            viewController.present(moreOptionsVC, animated: true)
        }
        viewController.present(moreOptionsVC, animated: true)
    }
}
