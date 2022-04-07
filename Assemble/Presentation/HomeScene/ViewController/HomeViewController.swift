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

final class HomeViewController: UIViewController {
    
    //MARK: - Constants
    
    //MARK: - Variables
    private let disposeBag = DisposeBag()
    
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
    }
    
    //MARK: - Binding
    
    private func configureUI() {
        // 스크롤뷰 상단 Safe Area 무시
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func bindViewModel() {
//        guard let viewModel = self.viewModel else { print("what"); return }
//        
//        // input
//        let input = FrontViewModel.Input(
//            
//        )
//        
//        // output
//        let output = viewModel.transform(from: input, disposeBag: self.disposeBag)
//        bindBannerCollectionView(output: output)
    }
}
