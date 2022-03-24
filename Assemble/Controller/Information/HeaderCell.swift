//
//  InfoCell.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/22.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    public let identifier: String = "HeaderCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameEnLabel: UILabel!
    @IBOutlet var childImages: [UIImageView]! {
        didSet {
            childImages.sort { $0.tag < $1.tag }
        }
    }
    @IBOutlet var childLabels: [UILabel]! {
        didSet {
            childLabels.sort { $0.tag < $1.tag }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
