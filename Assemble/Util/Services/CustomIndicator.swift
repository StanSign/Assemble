//
//  CustomIndicator.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/15.
//

import Kingfisher
import NVActivityIndicatorView

struct CustomIndicator: Indicator {
    let view: UIView = UIView()
    var subView: NVActivityIndicatorView
    
    func startAnimatingView() { view.isHidden = false }
    func stopAnimatingView() { view.isHidden = true }
    
    init(with size: CGSize) {
        subView = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: size), type: .ballBeat, color: .white, padding: nil)
        subView.startAnimating()
        view.addSubview(subView)
        
        subView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
