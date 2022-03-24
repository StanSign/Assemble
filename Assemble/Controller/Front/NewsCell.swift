//
//  NewsCell.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/16.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift

class NewsCell: UICollectionViewCell {
    
    //MARK: - Constants
    let realm = try! Realm()
    
    //MARK: - Variables
    var currentPage: Int = 0
    var newsCount: Int = 1
    var previousOffset: CGFloat = 0

    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setDelegates()
        registerXib()
    }

    //MARK: - Setup
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerXib() {
        let newsNib = UINib(nibName: "News", bundle: nil)
        collectionView.register(newsNib, forCellWithReuseIdentifier: "News")
    }
}

//MARK: - Collection View
extension NewsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "News", for: indexPath) as? News else {
            return UICollectionViewCell()
        }
        AssembleAPIManager.shared.requestNews { newsResults in
            self.setNewsCell(atIndex: indexPath.row, with: newsResults, to: cell)
        }
        return cell
    }
}

//MARK: - Scroll View Delegate
extension NewsCell: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = self.targetContentOffset(scrollView, withVelocity: velocity)
        targetContentOffset.pointee = point
        
        UIView.animate(withDuration: 0.1, animations: {
            self.collectionView.setContentOffset(point, animated: true)
        }, completion: nil)
    }

    func targetContentOffset(_ scrollView: UIScrollView, withVelocity velocity: CGPoint) -> CGPoint {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                
        if previousOffset > collectionView.contentOffset.x && velocity.x < 0 {
            currentPage = currentPage - 1
        } else if previousOffset < collectionView.contentOffset.x && velocity.x > 0 {
            currentPage = currentPage + 1
        }
        
        let cellWidth = UIScreen.main.bounds.width - 40
        let updatedOffset = (cellWidth + flowLayout.minimumLineSpacing) * CGFloat(currentPage)
        previousOffset = updatedOffset

        return CGPoint(x: updatedOffset, y: 0)
    }
}

//MARK: - Collection View Delegate Flow Layout
extension NewsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 40
        return .init(width: width, height: 160)
    }
}

//MARK: - Network

extension NewsCell {
    func setNewsCell(atIndex index: Int, with newsResults: [AssembleAPIManager.News], to cell: News) {
        let title = newsResults[index].title
        let type = newsResults[index].type
        let imgURL = URL(string: newsResults[index].thumbnail)
        let ytURL = newsResults[index].url
        
        if type == "youtube" {
            cell.videoIcon.isHidden = false
            cell.typeLabel.text = "YouTube"
        }
        cell.ytIDLabel.text = ytURL
        cell.titleLabel.text = title
        cell.image.kf.setImage(with: imgURL, options: [
            .processor(DownsamplingImageProcessor(size: cell.image.bounds.size)),
            .scaleFactor(UIScreen.main.scale),
            .forceRefresh
        ])
    }
}
