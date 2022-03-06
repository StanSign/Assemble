//
//  BannerCell.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/28.
//

import UIKit
import CHIPageControl
import SnapKit
import Kingfisher
import RealmSwift
import UIGradient

class BannerCell: UITableViewCell {
    
    //MARK: - Constants
    let network = Network()
    let realm = try! Realm()
    let pageControl = CHIPageControlJaloro(frame: CGRect(x: 0, y: 0, width: 100, height: 4))
    
    //MARK: - Variables
    var currentPage: Int = 0
    var isTimerActive: Bool = true
    var upcomingCount: Int = 1
    public var bannerTimer = Timer()
    
    //MARK: - IBOutlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setDelegates()
        setCollectionView()
        setPageControl()
        registerXib()
        
        autoScroll()
    }
    
    //MARK: - Setup
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
    }
    
    private func setCollectionView() {
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = true
        upcomingCount = realm.objects(Upcoming.self).count
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "Banner", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "Banner")
    }
    
    private func setPageControl() {
        bgView.addSubview(pageControl)
        pageControl.numberOfPages = upcomingCount
        pageControl.enableTouchEvents = false
        pageControl.hidesForSinglePage = true
        pageControl.padding = 0
        pageControl.radius = 1
        pageControl.currentPageTintColor = UIColor(named: "color1")
        pageControl.inactiveTransparency = 0.1
        pageControl.tintColor = .systemGray
        let leadingTrailingConstraint: CGFloat = 32.0
        pageControl.elementHeight = 3
        pageControl.elementWidth = (bgView.bounds.width / CGFloat(upcomingCount))
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.centerX.equalTo(collectionView)
            make.bottom.equalToSuperview()
        }
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
        return upcomingCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Banner", for: indexPath) as? Banner else {
                return UICollectionViewCell()
            }
            network.loadImageToBanner(atIndex: indexPath.row, to: cell)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Banner", for: indexPath) as? Banner else {
                return UICollectionViewCell()
            }
            network.loadImageToBanner(atIndex: indexPath.row, to: cell)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Banner", for: indexPath) as? Banner else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
    
}

//MARK: - Collection View Delegate Flow Layout

extension BannerCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.height)
    }
}

//MARK: - Collection View Prefetching
extension BannerCell: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        network.imagePrefetch()
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
