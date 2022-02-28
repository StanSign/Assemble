//
//  MenuBarLayout.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/13.
//

import Tabman
import SnapKit

class MenuBarLayout: TMBarLayout {
    
    private struct Defaults {
        static let contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    private let stackView = UIStackView()
    private var containers = [MenuBarButtonContainer]()
    
    override func layout(in view: UIView) {
        let paddedStackView = UIStackView()
        view.addSubview(paddedStackView)
        paddedStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        paddedStackView.addArrangedSubview(stackView)
        
        contentInset = Defaults.contentInset
    }
    
    override func insert(buttons: [TMBarButton], at index: Int) {
        buttons.forEach { (button) in
            let container = MenuBarButtonContainer(for: button)
            stackView.addArrangedSubview(container)
            containers.append(container)
            
            container.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 1/3).isActive = true
        }
    }
    
    override func remove(buttons: [TMBarButton]) {
        let containers = stackView.arrangedSubviews.compactMap({ $0 as? MenuBarButtonContainer })
        let containersToRemove = containers.filter({ buttons.contains($0.button) })
        containersToRemove.forEach { (container) in
            stackView.removeArrangedSubview(container)
            container.removeFromSuperview()
        }
    }
}
