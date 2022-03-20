//
//  Hero.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/13.
//

import UIKit

class Hero: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 24
    }

}
