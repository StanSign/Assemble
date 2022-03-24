//
//  DetailCell.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/23.
//

import UIKit

class DetailCell: UITableViewCell {
    
    //MARK: - Constants
    public let identifier = "DetailCell"

    @IBOutlet weak var detailHeaderlabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
