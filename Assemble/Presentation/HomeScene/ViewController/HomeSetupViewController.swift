//
//  SetupViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/28.
//

import UIKit

import Lottie
import RxSwift
import RxCocoa
import SnapKit

final class HomeSetupViewController: UIViewController {
    
    private var animationView: AnimationView?
    var viewModel: HomeSetupViewModel?
    var disposeBag = DisposeBag()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resumeSpinner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseSpinner()
    }
    
    //MARK: - Binding
    
    private func configureUI() {
        self.view.backgroundColor = .black
        loadSpinner()
    }
    
    private func bindViewModel() {
        let input = HomeSetupViewModel.Input(
            viewDidLoadEvent: Observable.just(())
        )
        
        _ = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
    }
}

private extension HomeSetupViewController {
    func loadSpinner() {
        animationView = .init(name: "Loader")
        animationView?.loopMode = .loop
        view.addSubview(animationView!)
        animationView?.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
    }
    
    func resumeSpinner() {
        animationView?.play()
    }
    
    func pauseSpinner() {
        animationView?.pause()
    }
}
