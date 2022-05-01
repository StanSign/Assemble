//
//  LoadingView.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/01.
//

import UIKit

import Lottie
import SnapKit

final class LoadingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init() {
        self.init(frame: .zero)
        self.configureUI()
    }
}

private extension LoadingView {
    func configureUI() {
        self.backgroundColor = .black
        
        let animationView: AnimationView
        animationView = .init(name: "Loader")
        animationView.loopMode = .loop
        self.addSubview(animationView)
        animationView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
        animationView.play()
    }
}
