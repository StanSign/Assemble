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

final class HomeViewController: UIViewController {
    
    //MARK: - Constants
    
    //MARK: - Variables
    var viewModel: HomeViewModel?
    var disposeBag = DisposeBag()
    
    //MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(
            viewDidLoadEvent: Observable.just(())
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.bannerData
            .bind(to: collectionView.rx.items(cellIdentifier: BannerCell.identifier, cellType: BannerCell.self)) { index, banners, cell in
                let cache = ImageCache.default
                if (cache.isCached(forKey: "bannerCache\(index)")) {
                    cache.retrieveImage(forKey: "bannerCache\(index)") { result in
                        switch result {
                        case .success(let value):
                            cell.upcomingImageView.image = value.image
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                cell.titleLabel.text = banners.title
                cell.subtitleLabel.text = banners.subtitle
                cell.stateLabel.text = banners.d_day
            }
            .disposed(by: self.disposeBag)
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
