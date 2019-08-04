//
//  OnBoardingViewController.swift
//  OnBoardingTestMVVM
//
//  Created by Serge Sukhanov on 8/4/19.
//  Copyright © 2019 Serge Sukhanov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OnBoardingViewController: UIViewController {
    
    let viewModel = OnBoardingViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWithViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.input.nextImageObserver.onNext(())
    }
    
    private func configureWithViewModel() {
        continueButton.rx.tap
            .subscribe(viewModel.input.nextImageObserver)
            .disposed(by: disposeBag)
        
        viewModel.output.showImageWithNameObservable
            .subscribe(onNext: { [weak self] imageName in
                self?.updateImageView(withName: imageName)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.updateButtonWithTitleObservable
            .subscribe(onNext: { [weak self] title in
                self?.updateButton(withTitle: title)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.startApplicationObservable
            .subscribe(onNext: { [weak self] in
                self?.startApplication()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateImageView(withName imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
    
    private func updateButton(withTitle title: String) {
        continueButton.setTitle(title, for: .normal)
    }
    
    private func startApplication() {
        print("Application is started")
    }
}
