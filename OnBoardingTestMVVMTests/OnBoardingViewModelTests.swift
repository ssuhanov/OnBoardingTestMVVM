//
//  OnBoardingViewModelTests.swift
//  OnBoardingTestMVVMTests
//
//  Created by Serge Sukhanov on 8/4/19.
//  Copyright © 2019 Serge Sukhanov. All rights reserved.
//

import XCTest
import RxSwift
@testable import OnBoardingTestMVVM

class OnBoardingViewModelTests: XCTestCase {
    
    class MockOnBoardingLocalManager: OnBoardingLocalManager {
        var setFlagOnBoardingCompleted_isCalled = false
        
        override func setFlagOnBoardingCompleted() {
            setFlagOnBoardingCompleted_isCalled = true
        }
    }
    
    let disposeBag = DisposeBag()
    
    var instance: OnBoardingViewModel!
    var mockLocalManager: MockOnBoardingLocalManager!
    
    let correctNextImageName = "correctNextImageName"
    var fullImageQueue: [String]!
    let lastImageQueue: [String] = ["something"]
    let emptyImageQueue: [String] = []
    
    override func setUp() {
        super.setUp()
        
        fullImageQueue = [correctNextImageName, "something", "something else"]
        mockLocalManager = MockOnBoardingLocalManager()
        instance = OnBoardingViewModel()
        instance.onBoardingLocalManager = mockLocalManager
    }
    
    func testNextImageExtractsCorrectly() {
        instance.imageQueue = fullImageQueue
        var resultImageName: String?
        
        instance.output.showImageWithNameObservable
            .subscribe(onNext: { resultImageName = $0 })
            .disposed(by: disposeBag)
        
        instance.input.nextImageObserver.onNext(())
        XCTAssertEqual(resultImageName, correctNextImageName, "should pass next in showImageWithName with image name \(correctNextImageName)")
    }
    
    func testImageQueueReducesCorrectly() {
        instance.imageQueue = fullImageQueue
        instance.input.nextImageObserver.onNext(())
        XCTAssertEqual(instance.imageQueue.count, fullImageQueue.count - 1, "image queue should be reduced by one")
    }
    
    func testButtonTitleUpdatesCorrectly() {
        instance.imageQueue = fullImageQueue
        var resultButtonTitle: String?
        
        instance.output.updateButtonWithTitleObservable
            .subscribe(onNext: { resultButtonTitle = $0 })
            .disposed(by: disposeBag)
        
        instance.input.nextImageObserver.onNext(())
        XCTAssertEqual(resultButtonTitle, "Continue", "should pass next in updateButtonWithTitle with title Continue")
    }
    
    func testPrepareForApplicationStartCorrectly() {
        instance.imageQueue = lastImageQueue
        var resultButtonTitle: String?
        
        instance.output.updateButtonWithTitleObservable
            .subscribe(onNext: { resultButtonTitle = $0 })
            .disposed(by: disposeBag)
        
        instance.input.nextImageObserver.onNext(())
        XCTAssertEqual(resultButtonTitle, "Start", "should pass next in updateButtonWithTitle with title Start")
    }
    
    func testApplicationStartsCorrectly() {
        instance.imageQueue = emptyImageQueue
        var startApplication_isCalled = false
        
        instance.output.startApplicationObservable
            .subscribe(onNext: { startApplication_isCalled = true })
            .disposed(by: disposeBag)
        
        instance.input.nextImageObserver.onNext(())
        XCTAssertTrue(startApplication_isCalled, "start application should be called")
    }
    
    func testLocalManagerSetsOnBoardingFlagCorrectly() {
        instance.imageQueue = emptyImageQueue
        instance.input.nextImageObserver.onNext(())
        XCTAssertTrue(mockLocalManager.setFlagOnBoardingCompleted_isCalled, "set flag onBoarding completed should be called")
    }
}
