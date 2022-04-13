//
//  Banner.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/28.
//

import UIKit
import FaceAware
import SnapKit

class Banner: UICollectionViewCell {
    
    static let identifier = "Banner"
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var gradientContainerView: UIView!
    @IBOutlet weak var labelStack: UIStackView!
    @IBOutlet weak var D_DayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var titleStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupGestures()
        setupGradientLayer()
    }
    
    private func setupGestures() {
        let titleTap = UITapGestureRecognizer(target: self, action: #selector(titleTapped))
        titleStack.addGestureRecognizer(titleTap)
    }
    
    @objc private func titleTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let navController = self.window?.rootViewController as! UINavigationController
        let storyboard = UIStoryboard(name: "Information", bundle: nil)
        let infoVC = storyboard.instantiateViewController(withIdentifier: "InformationVC") as! InformationViewController
        infoVC.id = bannerView.tag
        infoVC.type = .films
        infoVC.modalPresentationStyle = .fullScreen
        navController.pushViewController(infoVC, animated: true)
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0, 0.25, 0.5, 1]
        
        gradientContainerView.isUserInteractionEnabled = false
        gradientContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gradientContainerView.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = self.bounds
    }
}
