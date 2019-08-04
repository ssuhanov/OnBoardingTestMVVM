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
            .map { UIImage(named: $0) }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.output.updateButtonWithTitleObservable
            .bind(to: continueButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.output.startApplicationObservable
            .subscribe(onNext: { print("Application is started") })
            .disposed(by: disposeBag)
    }
}
