//
//  BannerCell.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/28.
//

import UIKit
import CHIPageControl
import SnapKit

class BannerCell: UITableViewCell {
    
    //MARK: - Variables
    var currentPage: Int = 0
    var isTimerActive: Bool = true
    public var bannerTimer = Timer()
    
    //MARK: - IBOutlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: CHIPageControlJaloro!
    
    //MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setDelegates()
        setCollectionView()
        registerXib()
        
        autoScroll()
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowOpacity = 0.2
        bgView.layer.shadowRadius = 16.0
        
        pageControl.elementWidth = (collectionView.bounds.width / 3) - 20
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
        if isTimerActive {
            bannerTimer.invalidate()
            fireTimer()
        }
    }
    
    private func fireTimer() {
        let totalCount = collectionView.numberOfItems(inSection: 0)
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { (Timer) in
            
            if self.currentPage >= totalCount - 1 {
                // Last Page
                self.currentPage = 0
            } else {
                self.currentPage += 1
            }
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentPage, section: 0), at: .right, animated: true)
            self.pageControl.set(progress: self.currentPage, animated: true)
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
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        bannerTimer.invalidate()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        currentPage = Int(ceil(x / w))
        pageControl.set(progress: currentPage, animated: true)
        fireTimer()
    }
}
