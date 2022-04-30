//
//  SearchTableViewCell.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/18.
//

import UIKit
import RxSwift
import RxCocoa

class SearchTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    static let identifier = "SearchResultCell"

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0))
    }

}
