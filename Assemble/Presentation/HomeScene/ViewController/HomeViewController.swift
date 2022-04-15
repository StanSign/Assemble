//
//  FrontViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import CHIPageControl

final class HomeViewController: UIViewController {
    
    //MARK: - Constants
    
    //MARK: - Variables
    var viewModel: HomeViewModel?
    var disposeBag = DisposeBag()
    
    //MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var pageControl: CHIPageControlJaloro = {
        let pageControl = CHIPageControlJaloro()
        pageControl.padding = 1
        pageControl.radius = 1
        pageControl.currentPageTintColor = .white.withAlphaComponent(0.75)
        pageControl.inactiveTransparency = 0.75
        pageControl.tintColor = .systemGray
        pageControl.elementHeight = 2
        pageControl.elementWidth = 20
        return pageControl
    }()
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var notifyButton: UIButton!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - Binding
    
    private func configureUI() {
        // 스크롤뷰 상단 Safe Area 무시
        scrollView.contentInsetAdjustmentBehavior = .never
        
        collectionView.delegate = self
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.rx.didEndDecelerating
            .subscribe(onNext: { value in
                let x = self.collectionView.contentOffset.x
                let w = self.collectionView.bounds.size.width
                let currentPage = Int(ceil(x / w))
                
                guard let count = self.viewModel?.upcomingCount else { return }
                self.collectionView.scrollToItem(
                    at: IndexPath(item: (currentPage % count) + count, section: 0),
                    at: .centeredHorizontally,
                    animated: false)
            })
            .disposed(by: self.disposeBag)
        
        view.addSubview(self.pageControl)
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalTo(self.collectionView.snp.bottom).inset(32)
            make.right.equalToSuperview().inset(32)
        }
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            bannerContentOffsetX: collectionView.rx.contentOffset.asObservable(),
            bannerBoundsWidth: Observable.just(collectionView.bounds.size.width),
            searchButtonDidTapEvent: searchButton.rx.tap.asObservable(),
            notifyButtonDidTapEvent: notifyButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.bannerData
            .bind(to: collectionView.rx.items(cellIdentifier: BannerCell.identifier, cellType: BannerCell.self)) { index, banners, cell in
                guard let count = self.viewModel?.upcomingCount else { return }
                self.setImage(with: banners.imageURL, to: cell, at: index, numberOfUpcomings: count)
                cell.titleLabel.text = banners.title
                cell.subtitleLabel.text = banners.subtitle
                cell.stateLabel.text = banners.d_day
            }
            .disposed(by: self.disposeBag)
        
        output?.didLoadBanner
            .subscribe(onNext: { _ in // Bool
                self.collectionView.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        output?.bannerCount
            .subscribe(onNext: { count in
                self.pageControl.numberOfPages = count
            })
            .disposed(by: self.disposeBag)
        
        output?.currentBannerPage
            .subscribe(onNext: { currentPage in
                self.pageControl.set(progress: currentPage ?? 0, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        collectionView.rx.prefetchItems
            .map({ $0.map({ $0.item }) })
            .withLatestFrom(output!.bannerData) { indexes, elements in
                indexes.map({ elements[$0] })
            }
            .map({ $0.compactMap({ URL(string: $0.imageURL) }) })
            .subscribe(onNext: {
                ImagePrefetcher(urls: $0).start()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setImage(with imageURL: String, to cell: BannerCell, at index: Int, numberOfUpcomings: Int) {
        let cache = ImageCache.default
        guard let url = URL(string: imageURL) else { return }
        let indicator = CustomIndicator(with: CGSize(width: 32, height: 32))
        cell.upcomingImageView.kf.indicatorType = .custom(indicator: indicator)
        cell.upcomingImageView.kf.setImage(
            with: url,
            options: [
                .waitForCache,
                .onlyFromCache
            ]) { _ in
                cache.retrieveImage(forKey: "bannerCache\(index % numberOfUpcomings)") { result in
                    switch result {
                    case .success(let value):
                        cell.upcomingImageView.image = value.image
                    case .failure(let error):
                        print(error)
                    }
                }
            }
    }
}

//MARK: - CollectionView Delegate Flow Layout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = width * 1.3
        let size = CGSize(width: width, height: height)
        return size
    }
}
