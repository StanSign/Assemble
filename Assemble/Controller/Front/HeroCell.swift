//
//  HeroCell.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/13.
//

import UIKit
import UIImageColors

class HeroCell: UICollectionViewCell {

    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setDelegates()
        registerXib()
        
        titleLabel.text = "히어로 모아보기"
    }

    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerXib() {
        let heroNib = UINib(nibName: "Hero", bundle: nil)
        collectionView.register(heroNib, forCellWithReuseIdentifier: "Hero")
    }
}

extension HeroCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hero", for: indexPath) as? Hero else {
            return UICollectionViewCell()
        }
        let character = FrontComposition.heroCellCharacters[indexPath.row]
        cell.nameLabel.text = character.name
        cell.imageView.image = UIImage(named: character.nameEn)
        cell.imageView.image?.getColors { colors in
            cell.bgView?.backgroundColor = colors?.primary
        }
        return cell
    }
}

extension HeroCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 90)
    }
}
