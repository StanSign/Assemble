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
        searchBarView.layer.cornerRadius = searchBarView.bounds.height / 2
        searchBar.becomeFirstResponder()
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
            .bind(to: self.tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { index, searchResult, cell in
                cell.titleLabel.text = searchResult.name
                cell.typeLabel.text = searchResult.type
            }
            .disposed(by: self.disposeBag)
    }
}
