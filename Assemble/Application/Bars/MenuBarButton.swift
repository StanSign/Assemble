//
//  MenuBarButton.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/13.
//

import Tabman
import SnapKit

class MenuBarButton: TMBarButton {
    
    private struct Defaults {
        static let imageSize = CGSize(width: 28, height: 28)
        static let unselectedScale: CGFloat = 0.8
    }
    
    private let imageView = UIImageView()
    
    override var tintColor: UIColor! {
        didSet {
            update(for: self.selectionState)
        }
    }
    var unselectedTintColor: UIColor = Colors.unselectedGray {
        didSet {
            update(for: self.selectionState)
        }
    }
    
    override func layout(in view: UIView) {
        super.layout(in: view)
        
        adjustsAlphaOnSelection = false
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(Defaults.imageSize.width)
            make.height.equalTo(Defaults.imageSize.height)
        }
    }
    
    override func populate(for item: TMBarItemable) {
        super.populate(for: item)
        
        imageView.image = item.image
    }
    
    override func update(for selectionState: TMBarButton.SelectionState) {
        super.update(for: selectionState)
        
        imageView.tintColor = unselectedTintColor.interpolate(with: tintColor, percent: selectionState.rawValue)
        let scale = 1.0 - ((1.0 - selectionState.rawValue) * (1.0 - Defaults.unselectedScale))
        imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
