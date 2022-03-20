//
//  News.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/16.
//

import UIKit

class News: UICollectionViewCell {
    
    var ytURL: URL?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var ytIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 16.0
        ytIDLabel.layer.opacity = 0
        
        setupGestures()
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        containerView.addGestureRecognizer(tap)
    }
    
    @objc private func tapped() {
        let youtubeId = ytIDLabel.text
        let splitYTID = youtubeId?.components(separatedBy: "/")
        let ytID = splitYTID?.last
        var ytURL = URL(string:"youtube://\(ytID!)")
        if UIApplication.shared.canOpenURL(ytURL!) {
            UIApplication.shared.open(ytURL!)
        } else {
            ytURL = URL(string:"https://www.youtube.com/watch?v=\(ytID!)")
            UIApplication.shared.open(ytURL!)
        }
    }
}
