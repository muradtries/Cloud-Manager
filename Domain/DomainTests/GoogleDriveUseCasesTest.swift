//
//  GoogleDriveUseCasesTest.swift
//  DomainTests
//
//  Created by Murad on 29.09.22.
//

import XCTest
import Promises
import RxSwift

@testable import Domain

class GoogleDriveUseCasesTest: XCTestCase {
    
    var googleDriveRepo: GoogleDriveRepoMockData!
    var compositeDisposable: CompositeDisposable!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.googleDriveRepo = GoogleDriveRepoMockData()
        self.compositeDisposable = CompositeDisposable()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.compositeDisposable.dispose()
    }
    
    func testObserveGoogleDriveInfoSuccess() {
        let useCase = ObserveGoogleDriveInfoUseCase(repo: self.googleDriveRepo)
        
        let expectedInfo = GoogleDriveInfoEntity(ownerDisplayName: "Murad",
                                                 profilePhotoLink: "https://www.google.com",
                                                 ownerEmailAdress: "abbasovmurad45@gmail.com",
                                                 storageLimit: "15002332242",
                                                 storageUsage: "7828329321",
                                                 storageUsageInDrive: "3434294832",
                                                 storageUsageInTrash: "0")
        
        let expectation = XCTestExpectation(description: "Observe info should be observed")
        
        var returnedInfo: GoogleDriveInfoEntity!
        
        let subscription = useCase.observeInfo()
            .subscribe { received in
                guard let data = received.element else {
                    XCTFail("Info is nil")
                    return
                }
                
                returnedInfo = data
                expectation.fulfill()
            }
        
        let _ = compositeDisposable.insert(subscription)
        
        self.googleDriveRepo.observeInfoObservable.accept(expectedInfo)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(returnedInfo, expectedInfo)
    }
    
    func testSyncUserUseCaseSucces() {
        let useCase = SyncGoogleDriveInfoUseCase(repo: self.googleDriveRepo)
        
        self.googleDriveRepo.syncInfoPromise = Promise<Void>.pending()
        
        let expectation = XCTestExpectation()
        
        useCase.syncInfo()
            .then { _ in
                expectation.fulfill()
            }
            .catch { _ in
                XCTFail()
            }
        
        self.googleDriveRepo.syncInfoPromise.fulfill(())
        
        wait(for: [expectation], timeout: 1.0)
    }
}

extension GoogleDriveInfoEntity: Equatable {
    public static func == (lhs: GoogleDriveInfoEntity, rhs: GoogleDriveInfoEntity) -> Bool {
        return lhs.ownerDisplayName == rhs.ownerDisplayName && lhs.profilePhotoLink == rhs.profilePhotoLink && lhs.ownerEmailAdress == rhs.ownerEmailAdress && lhs.storageLimit == rhs.storageLimit
    }
}
