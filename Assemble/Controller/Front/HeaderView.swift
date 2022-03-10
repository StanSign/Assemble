//
//  HeaderView.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/08.
//

import UIKit
import SnapKit

class HeaderView: UICollectionReusableView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bannerViewNib = Bundle.main.loadNibNamed("BannerView", owner: self, options: nil)
        let bannerView = bannerViewNib?.first as! BannerView
        let imView = UIImageView()
        imView.image = UIImage(named: "bt")
        
        backgroundColor = .clear
        addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
