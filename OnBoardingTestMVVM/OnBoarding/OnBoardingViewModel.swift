//
//  OnBoardingViewModel.swift
//  OnBoardingTestMVVM
//
//  Created by Serge Sukhanov on 8/4/19.
//  Copyright © 2019 Serge Sukhanov. All rights reserved.
//

import Foundation
import RxSwift

class OnBoardingViewModel {
    
    let disposeBag = DisposeBag()

    var imageQueue: [String] = OnBoardingImageManager().getImageQueue()
    var onBoardingLocalManager = OnBoardingLocalManager()
    
    struct Input {
        var nextImageObserver: AnyObserver<Void>
    }
    
    struct Output {
        var showImageWithNameObservable: Observable<String>
        var updateButtonWithTitleObservable: Observable<String>
        var startApplicationObservable: Observable<Void>
    }
    
    private var nextImageSubject = PublishSubject<Void>()
    private var showImageWithNameSubject = PublishSubject<String>()
    private var updateButtonWithTitleSubject = PublishSubject<String>()
    private var startApplicationSubject = PublishSubject<Void>()
    
    var input: Input
    var output: Output
    
    init() {
        self.input = Input(nextImageObserver: nextImageSubject.asObserver())
        
        self.output = Output(showImageWithNameObservable: showImageWithNameSubject.asObservable(),
                             updateButtonWithTitleObservable: updateButtonWithTitleSubject.asObservable(),
                             startApplicationObservable: startApplicationSubject.asObservable())
        
        nextImageSubject
            .subscribe(onNext: { [weak self] in
                self?.handleNextImage()
            })
            .disposed(by: disposeBag)
    }
    
    private func handleNextImage() {
        if let nextImageName = imageQueue.first {
            showImageWithNameSubject.onNext(nextImageName)
            imageQueue = Array(imageQueue.dropFirst())
            
            let buttonTitle = imageQueue.isEmpty ? "Start" : "Continue"
            updateButtonWithTitleSubject.onNext(buttonTitle)
            
        } else {
            startApplicationSubject.onNext(())
            onBoardingLocalManager.setFlagOnBoardingCompleted()
        }
    }
}
