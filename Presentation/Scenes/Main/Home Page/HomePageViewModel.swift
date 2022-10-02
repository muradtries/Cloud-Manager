//
//  HomePageViewModel.swift
//  Presentation
//
//  Created by Murad on 30.08.22.
//

import Foundation
import Domain
import Promises
import RxSwift
import UIKit

protocol HomePageNavigationDelegate: AnyObject {
    func goToGoogleDriveController()
    func goToDropboxController()
}

protocol HomePagePresentationDelegate: AnyObject {
    func presentCloudServices(viewController: HomePageController)
}

class HomePageViewModel {
    
    weak var navigationDelegate: HomePageNavigationDelegate?
    weak var presentationDelegate: HomePagePresentationDelegate?

    let connectGoogleDriveUseCase: ConnectGoogleDriveUseCase
    let connectDropboxUseCase: ConnectDropboxUseCase
    let restoreUserUseCase: RestoreUserUseCase
    let syncGoogleDriveInfoUseCase: SyncGoogleDriveInfoUseCase
    let syncDropboxInfoUseCase: SyncDropboxInfoUseCase
    let observeGoogleDriveInfoUseCase: ObserveGoogleDriveInfoUseCase
    let observeDropboxInfoUseCase: ObserveDropboxInfoUseCase
    
    init(delegate: HomePageNavigationDelegate,
         connectGoogleDriveUseCase: ConnectGoogleDriveUseCase,
         connectDropboxUseCase: ConnectDropboxUseCase,
         restoreUserUseCase: RestoreUserUseCase,
         syncGoogleDriveInfoUseCase: SyncGoogleDriveInfoUseCase,
         syncDropboxInfoUseCase: SyncDropboxInfoUseCase,
         observeGoogleDriveInfoUseCase: ObserveGoogleDriveInfoUseCase,
         observeDropboxInfoUseCase: ObserveDropboxInfoUseCase) {
        self.navigationDelegate = delegate
        self.connectGoogleDriveUseCase = connectGoogleDriveUseCase
        self.connectDropboxUseCase = connectDropboxUseCase
        self.restoreUserUseCase = restoreUserUseCase
        self.syncGoogleDriveInfoUseCase = syncGoogleDriveInfoUseCase
        self.syncDropboxInfoUseCase = syncDropboxInfoUseCase
        self.observeGoogleDriveInfoUseCase = observeGoogleDriveInfoUseCase
        self.observeDropboxInfoUseCase = observeDropboxInfoUseCase
    }
    
    func syncGoogleDriveInfo() -> Promise<Void> {
        self.syncGoogleDriveInfoUseCase.syncInfo()
    }
    
    func syncDropboxInfo() -> Promise<Void> {
        self.syncDropboxInfoUseCase.syncInfo()
    }
    
    func observeGoogleDriveInfo() -> Observable<GoogleDriveInfoEntity> {
        self.observeGoogleDriveInfoUseCase.observeInfo()
            .observe(on: MainScheduler.instance)
    }
    
    func observeDropboxInfo() -> Observable<DropboxInfoEntity> {
        self.observeDropboxInfoUseCase.observeInfo()
            .observe(on: MainScheduler.instance)
    }
    
    func restoreUser() -> Promise<Void> {
        self.restoreUserUseCase.execute
    }
    
    func presentCloudServices(viewController: HomePageController) {
        self.presentationDelegate?.presentCloudServices(viewController: viewController)
    }
    
    func goToGoogleDriveController() {
        self.navigationDelegate?.goToGoogleDriveController()
    }
    
    func goToDropboxController() {
        self.navigationDelegate?.goToDropboxController()
    }
    
    func connectToGoogleDrive(presenting: UIViewController) {
        self.connectGoogleDriveUseCase.signIn(presenting: presenting).then { _ in
            self.navigationDelegate?.goToGoogleDriveController()
            print("SUCCESSFULLY CONNECTED TO GOOGLE DRIVE")
        }.catch { _ in
            print(NSError(domain: "connectGoogleDriveUseCase", code: 1))
            return
        }
    }
    
    func connectToDropbox(presenting: UIViewController) {
        self.connectDropboxUseCase.signIn(presenting: presenting).then { _ in
            self.navigationDelegate?.goToDropboxController()
            print("SUCCESSFULLY CONNECTED TO DROPBOX")
        }.catch { _ in
            print(NSError(domain: "connectDropboxUseCase", code: 1))
            return
        }
    }
}
