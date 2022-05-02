//
//  News.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/02.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    static let identifier = "NewsCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var videoIconView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tagLabel.layer.opacity = 0
    }
}
