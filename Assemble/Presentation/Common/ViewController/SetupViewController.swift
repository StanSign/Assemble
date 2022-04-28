//
//  SetupViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/28.
//

import UIKit
import Lottie

final class SetupViewController: UIViewController {
    
    private var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        configureUI()
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
        animationView?.play()
    }
}
