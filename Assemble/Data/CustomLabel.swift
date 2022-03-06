//
//  CustomLabel.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/04.
//

import UIKit

class CustomLabel: UILabel {

    @IBInspectable var characterSpacing: CGFloat = 1 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text!)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: self.characterSpacing, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }

}
