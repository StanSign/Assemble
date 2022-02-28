//
//  BannerCell.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/28.
//

import UIKit

class BannerCell: UITableViewCell {
    
    //MARK: - Variables
    var currentPage: Int = 0
    public var bannerTimer = Timer()
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setDelegates()
        setCollectionView()
        registerXib()
        
        autoScroll()
    }
    
    //MARK: - Setup
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setCollectionView() {
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = true
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "Banner", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "Banner")
    }
    
    private func autoScroll() {
        let totalCount = collectionView.numberOfItems(inSection: 0)
        
        bannerTimer.invalidate()
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (Timer) in
            
            if self.currentPage >= totalCount - 1 {
                // Last Page
                self.currentPage = 0
            } else {
                self.currentPage += 1
            }
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentPage, section: 0), at: .right, animated: true)
        }
    }
}

//MARK: - Collection View

extension BannerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Banner", for: indexPath) as? Banner else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
}

//MARK: - Collection View Delegate Flow Layout

extension BannerCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

//MARK: - Scroll View Delegate

extension BannerCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        currentPage = Int(ceil(x / w))
//        print(currentPage)
    }
}
