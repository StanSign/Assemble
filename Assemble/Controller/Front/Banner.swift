//
//  Banner.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/28.
//

import UIKit
import FaceAware
import UIGradient
import SnapKit

class Banner: UICollectionViewCell {
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var D_DayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var titleStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupGestures()
    }
    
    private func setupGestures() {
        let titleTap = UITapGestureRecognizer(target: self, action: #selector(titleTapped))
        titleStack.addGestureRecognizer(titleTap)
    }
    
    @objc private func titleTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("\(bannerView.tag)")
    }
}
