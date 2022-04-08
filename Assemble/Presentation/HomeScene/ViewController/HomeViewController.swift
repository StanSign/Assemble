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
    private let disposeBag = DisposeBag()
    
    //MARK: - Variables
    var viewModel: HomeViewModel?
    
    //MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    //MARK: - Binding
    
    private func configureUI() {
        // 스크롤뷰 상단 Safe Area 무시
        scrollView.contentInsetAdjustmentBehavior = .never
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let bannerNib = UINib(nibName: "Banner", bundle: nil)
        collectionView.register(bannerNib, forCellWithReuseIdentifier: "Banner")
    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(
            viewDidLoadEvent: Observable.just(())
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
    }
}

//MARK: - CollectionView Delegate Flow Layout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = width * 1.3
        let size = CGSize(width: width, height: height)
        return size
    }
}

//MARK: - CollectionView DataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let upcomingList = self.viewModel?.upcomingList else { return 1 }
        print(upcomingList.count)
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Banner", for: indexPath) as? Banner else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = viewModel?.upcomingList?.upcomings.first?.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("View Model: \(self.viewModel?.upcomingList)")
    }
}
