//
//  CustomBannerLayout.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/09.
//

import UIKit

class CustomBannerLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        layoutAttributes?.forEach({ attributes in
            guard let collectionView = collectionView else { return }
            let contentOffsetY = collectionView.contentOffset.y
            print(contentOffsetY)
            if contentOffsetY > 0 {
                return
            }
            let width = collectionView.frame.width
            let height = attributes.frame.height - contentOffsetY
            attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
        })
        return layoutAttributes
    }
    
}
