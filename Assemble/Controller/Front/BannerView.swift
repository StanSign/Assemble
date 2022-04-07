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

class BannerView: UICollectionViewCell {
    
    //MARK: - Constants
    let identifier = "BannerView"
    let pageControl = CHIPageControlChimayo(frame: CGRect(x: 0, y: 0, width: 100, height: 4))
    
    //MARK: - Variables
    var currentPage: Int = 0
    var upcomingCount: Int = 1
    var actualPageCount: Int?
    var isTimerActive: Bool = true
    public var bannerTimer = Timer()
    
    //MARK: - IBOutlets
    @IBOutlet weak var pageControlContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setDelegates()
        setCollectionView()
        setPageControl()
        registerXib()
    }
    
    //MARK: - Setup
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setCollectionView() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = true
        actualPageCount = upcomingCount * 3
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "Banner", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "Banner")
    }
    
    private func setPageControl() {
        pageControlContainer.addSubview(pageControl)
        pageControl.numberOfPages = upcomingCount
        pageControl.enableTouchEvents = false
        pageControl.hidesForSinglePage = true
        pageControl.padding = 0
        pageControl.radius = 4
        pageControl.currentPageTintColor = .white.withAlphaComponent(0.75)
        pageControl.inactiveTransparency = 0.75
        pageControl.padding = 8
        pageControl.tintColor = .systemGray
        pageControl.snp.makeConstraints { make in
            make.width.equalTo(8 + (4 * 2 * actualPageCount!))
            make.trailing.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}

//MARK: - Collection View

extension BannerView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actualPageCount!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Banner", for: indexPath) as? Banner else {
            return UICollectionViewCell()
        }
        AssembleAPIManager.shared.requestBanner { upcomingResults in
            self.loadImageToBanner(atIndex: 0, with: upcomingResults, to: cell)
        }
        return cell
    }
    
}

//MARK: - Collection View Delegate Flow Layout

extension BannerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

//MARK: - Scroll View Delegate

extension BannerView: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        bannerTimer.invalidate()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        currentPage = Int(ceil(x / w))
        
        collectionView.reloadData()
        pageControl.set(progress: currentPage % 2, animated: true)
        collectionView.scrollToItem(at: IndexPath(item: (currentPage % 2) + upcomingCount, section: 0), at: .centeredHorizontally, animated: false)
    }
}

//MARK: - Network

extension BannerView {
    func loadImageToBanner(atIndex index: Int, with upcomingResults: [AssembleAPIManager.Film], to cell: Banner) {
        let imgURL = URL(string: upcomingResults[index].fImage!)
        let fNM = upcomingResults[index].fNM
        let releaseDate = upcomingResults[index].fReleaseDate
        let fID = upcomingResults[index].fID
        
        let imgIndicator = CustomIndicator()
        cell.bannerImage.kf.indicatorType = .custom(indicator: imgIndicator)
        cell.bannerImage.kf.setImage(with: imgURL, options: [
            .processor(DownsamplingImageProcessor(size: cell.bannerImage.bounds.size)),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ])
        
        let split_fNM = fNM.components(separatedBy: [":"])
        // Title
        cell.titleLabel.text = split_fNM.first
        // Subtitle
        if split_fNM.first != split_fNM.last {
            cell.subLabel.text = split_fNM.last
        } else {
            cell.subLabel.text = ""
        }
        // D-Day Counter
        let D_Day = DateTime().calculateDday(fromDate: releaseDate!)
        switch D_Day {
        case Int.min ..< 0:
            cell.D_DayLabel.text = "D+\(abs(D_Day))"
        case 0 ..< Int.max:
            cell.D_DayLabel.text = "D-\(abs(D_Day))"
        case 0:
            cell.D_DayLabel.text = "D-Day"
        default:
            break
        }
        // Tag
        cell.bannerView.tag = fID
    }
}
