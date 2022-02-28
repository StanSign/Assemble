//
//  Banner.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/28.
//

import UIKit

class Banner: UICollectionViewCell {
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bannerView.layer.cornerRadius = 16.0
    }

}
