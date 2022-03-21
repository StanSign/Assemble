//
//  SearchViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/17.
//

import UIKit
import Hero
import RxSwift
import RxCocoa
import Kingfisher

class SearchViewController: UIViewController {
    
    //MARK: - Constants
    
    //MARK: - Variables
    var isSwipeNotRecognized = true
    var disposeBag = DisposeBag()
    var searchResultList = PublishSubject<[AssembleAPIManager.Search]>()

    //MARK: - IBOutlets
    @IBOutlet weak var backIcon: UIImageView!
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var screenEdgePanRecognizer: UIScreenEdgePanGestureRecognizer!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupEdgePanGesture()
        setupGestures()
        setupSearchBar()
        setupTableView()
        
        self.hero.isEnabled = true
        searchIcon.hero.id = "searchIcon"
        bgView.hero.modifiers = [.fade]
        
        RxSearch()
        tableViewSelected()
    }
    
    //MARK: - Setup
    
    private func setupEdgePanGesture() {
        screenEdgePanRecognizer.edges = .left
    }
    
    private func setupGestures() {
        let backIconTap = UITapGestureRecognizer(target: self, action: #selector(backIconTapped))
        backIcon.addGestureRecognizer(backIconTap)
    }
    
    private func setupSearchBar() {
        searchContainer.layer.cornerRadius = self.searchContainer.bounds.height / 2
        searchTextField.becomeFirstResponder()
    }
    
    @objc private func backIconTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupTableView() {
        tableView.rx.didEndDisplayingCell
            .subscribe { event in
                let cell = event.element?.cell as? SearchTableViewCell
                cell?.disposeBag = DisposeBag()
                cell?.cellImage.kf.cancelDownloadTask()
            }
            .disposed(by: disposeBag)
    }
    
    private func RxSearch() {
        AssembleAPIManager.shared.searchResultList = self.searchResultList
        searchTextField.rx.text
            .orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe (onNext: { changedText in
                AssembleAPIManager.shared.requestSearchData(query: changedText)
                self.search(changedText)
            })
            .disposed(by: disposeBag)
    }
    
    private func search(_ searchText: String) {
        if searchText == "" {
            tableView.isHidden = true
        } else {
            tableView.dataSource = nil
            tableView.delegate = nil
            tableView.isHidden = false
            searchResultList
                .bind(to: self.tableView.rx.items(cellIdentifier: "SearchResultCell", cellType: SearchTableViewCell.self)) { (index, model, cell) in
                    self.setCell(model, cell)
                }
                .disposed(by: disposeBag)
        }
    }
    
    private func setCell(_ model: AssembleAPIManager.Search, _ cell: SearchTableViewCell) {
        cell.backgroundColor = .clear
        
        let url = model.image
        AssembleAPIManager.shared.requestAndSetImage(to: cell.cellImage, with: url)
        
        cell.typeLabel.text = AssembleAPIManager.shared.convertType(model.type)
        
        if (model.name != nil) {
            cell.titleLabel.text = model.name
        } else {
            cell.titleLabel.text = model.name_En
        }
    }
    
    private func tableViewSelected() {
        tableView.rx.modelSelected(AssembleAPIManager.Search.self)
            .subscribe(onNext: { model in
                print("\(model.id) was selected")
                let navController = self.navigationController
                let storyboard = UIStoryboard(name: "Information", bundle: nil)
                let infoVC = storyboard.instantiateViewController(withIdentifier: "InformationVC") as! InformationViewController
                infoVC.id = model.id
                infoVC.type = AssembleAPIManager.contentType(rawValue: model.type)
                infoVC.modalPresentationStyle = .fullScreen
                navController?.pushViewController(infoVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func screenEdgePanned(_ sender: Any) {
        if isSwipeNotRecognized {
            isSwipeNotRecognized = false
            self.navigationController?.popViewController(animated: true)
        }
    }
}
