//
//  MenuBarButtonContainer.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/14.
//

import UIKit
import Tabman
import SnapKit

class MenuBarButtonContainer: UIView {
    
    internal let button: TMBarButton
    
    private var xAnchor: NSLayoutConstraint!
    
    var offsetDelta: CGFloat = 0.0 {
        didSet {
            xAnchor.constant = offsetDelta * (button.frame.size.width)
        }
    }
    
    init(for button: TMBarButton) {
        self.button = button
        super.init(frame: .zero)
        initialize(with: button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize(with button: TMBarButton) {
        
        xAnchor = button.centerXAnchor.constraint(equalTo: centerXAnchor)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([xAnchor])
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
