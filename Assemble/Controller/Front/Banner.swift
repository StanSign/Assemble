//
//  Banner.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/28.
//

import UIKit
import FaceAware
import UIGradient
import Kingfisher

class Banner: UICollectionViewCell {
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var D_DayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var maskingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        maskingView.layer.opacity = 1
        maskingView.backgroundColor = UIColor.fromGradientWithDirection(.bottomToTop, frame: self.frame, colors: [.black, .clear])
    }
}
