//
//  Loader.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/21.
//

import Kingfisher
import Lottie
import SnapKit

struct Loader: Indicator {
    var view: IndicatorView = IndicatorView()
    let lottie = AnimationView(name: "Loader")
    
    func startAnimatingView() {
        view.isHidden = false
        lottie.play()
    }
    
    func stopAnimatingView() {
        lottie.stop()
        view.isHidden = true
    }
    
    init() {
        view.backgroundColor = .clear
        lottie.loopMode = .loop
        view.addSubview(lottie)
        lottie.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
    }
}
