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
import Lottie

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
    @IBOutlet weak var newsView: NewsView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var notifyButton: UIButton!
    lazy var loadingView = LoadingView()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: -
    
    private func configureUI() {
        // 스크롤뷰 상단 Safe Area 무시
        scrollView.contentInsetAdjustmentBehavior = .never
        
        self.configureLoader()
        self.configureBanner()
        self.configureNews()
    }
    
    //MARK: - Binding
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(
            viewDidLoadEvent: Observable.just(()).asObservable(),
            viewDidAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewDidAppear)).map { _ in },
            bannerContentOffset: self.collectionView.rx.contentOffset.asObservable(),
            bannerBoundsWidth: Observable.just(self.collectionView.bounds.size.width),
            collectionViewDidEndDecelerating: self.collectionView.rx.didEndDecelerating.asObservable(),
            searchButtonDidTapEvent: searchButton.rx.tap.asObservable(),
            notifyButtonDidTapEvent: notifyButton.rx.tap.asObservable()
        )
        
        guard let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag) else {
            return
        }
        
        output.isFetchFinished
            .filter({ $0 == true })
            .subscribe(onNext: { a in
                self.loadingView.isHidden = true
            })
            .disposed(by: self.disposeBag)
        
        output.bannerData
            .bind(to: collectionView.rx.items(cellIdentifier: BannerCell.identifier, cellType: BannerCell.self)) { index, banners, cell in
                cell.titleLabel.text = banners.title
                cell.subtitleLabel.text = banners.subtitle
                cell.stateLabel.text = banners.d_day
                cell.upcomingImageView.setImage(with: banners.imageURL)
            }
            .disposed(by: self.disposeBag)
        
        output.bannerInitialPage
            .asDriver(onErrorJustReturn: 0)
            .delay(.milliseconds(100))
            .drive(onNext: { initialPage in
                self.collectionView.scrollToItem(
                    at: IndexPath(item: initialPage, section: 0),
                    at: .centeredHorizontally,
                    animated: false
                )
            })
            .disposed(by: self.disposeBag)
        
        output.bannerData
            .subscribe(onNext: { data in
                self.pageControl.numberOfPages = data.count / 3
            })
            .disposed(by: self.disposeBag)
        
        output.bannerPresentedPage
            .subscribe(onNext: { page in
                self.pageControl.set(progress: page, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.didEndDecelerating
            .withLatestFrom(output.scrollTo) { $1 }
            .subscribe(onNext: { a in
                self.collectionView.scrollToItem(
                    at: IndexPath(item: a, section: 0),
                    at: .centeredHorizontally,
                    animated: false
                )
            }).disposed(by: self.disposeBag)
    }
}

//MARK: - UI Configuration

private extension HomeViewController {
    func configureLoader() {
        view.addSubview(self.loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureBanner() {
        self.collectionView.delegate = self
        self.collectionView.register(
            BannerCell.self,
            forCellWithReuseIdentifier: BannerCell.identifier
        )
        
        view.addSubview(self.pageControl)
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalTo(self.collectionView.snp.bottom).inset(32)
            make.right.equalToSuperview().inset(32)
        }
    }
    
    func configureNews() {
        self.newsView.titleLabel.text = "What's New"
        self.newsView.subtitleLabel.text = "새로운 소식"
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
