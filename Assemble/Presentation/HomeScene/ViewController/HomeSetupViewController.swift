//
//  SetupViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/28.
//

import UIKit
import Lottie

final class HomeSetupViewController: UIViewController {
    
    private var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        resumeSpinner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        pauseSpinner()
    }
    
    private func configureUI() {
        loadSpinner()
    }
    
    private func loadSpinner() {
        animationView = .init(name: "Loader")
        animationView?.loopMode = .loop
        view.addSubview(animationView!)
        animationView?.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
    }
    
    private func resumeSpinner() {
        animationView?.play()
    }
    
    private func pauseSpinner() {
        animationView?.pause()
    }
}
