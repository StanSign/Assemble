//
//  SearchViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/15.
//

import UIKit

import RxSwift
import RxDataSources
import RxGesture
import Kingfisher

class SearchViewController: UIViewController {
    
    //MARK: - Constants
    
    //MARK: - Variables
    var viewModel: SearchViewModel?
    var disposeBag = DisposeBag()
    
    //MARK: - IBOutlets
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bindViewModel()
    }
    
    private func configureUI() {
        self.searchBarView.layer.cornerRadius = searchBarView.bounds.height / 2
        self.searchBar.becomeFirstResponder()
        
        self.tableView.rx.didEndDisplayingCell
            .subscribe(onNext: { cell, indexPath in
                let cell = cell as! SearchTableViewCell
                cell.cellImage.kf.cancelDownloadTask()
                cell.disposeBag = DisposeBag()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindViewModel() {
        let input = SearchViewModel.Input(
            backButtonDidTapEvent: self.backButton.rx.tap.asObservable(),
            screenEdgePanGestureEvent: self.view.rx
                .anyGesture(
                    .swipe(direction: .right)
                )
                .when(.recognized)
                .map({ _ in })
                .asObservable(),
            searchBarEvent: self.searchBar.rx.text.orEmpty.asObservable()
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: self.disposeBag)
        
        output?.searchResults
            .filter({ !$0.isEmpty })
            .do(onNext: { _ in
                self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            })
            .bind(to: self.tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { index, searchResult, cell in
                if searchResult.name != "" {
                    cell.titleLabel.text = searchResult.name
                } else {
                    cell.titleLabel.text = searchResult.nameEn
                }
                cell.typeLabel.text = searchResult.type
                cell.cellImage.kf.indicatorType = .activity
                if searchResult.imageURL != "" {
                    let kfOption: KingfisherOptionsInfo = [
                        .processor(DownsamplingImageProcessor(size: cell.bounds.size)),
                        .cacheOriginalImage,
                        .scaleFactor(UIScreen.main.scale)
                    ]
                    cell.cellImage.setImage(with: searchResult.imageURL, options: kfOption)
                }
            }
            .disposed(by: self.disposeBag)
        
        output?.queryEmpty
            .subscribe(onNext: { isEmpty in
                if isEmpty {
                    self.tableView.isHidden = true
                } else {
                    self.tableView.isHidden = false
                }
            })
            .disposed(by: self.disposeBag)
    }
}
