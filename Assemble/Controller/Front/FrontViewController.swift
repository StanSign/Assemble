//
//  FrontViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/27.
//

import UIKit

class FrontViewController: UIViewController {
    
    //MARK: - Constants
    private let closedHeaderHeight: CGFloat = 65
    private let openHeaderHeight: CGFloat = 130
    private let lowerLimit: CGFloat = 0
    private let upperLimit: CGFloat = 65 // openHeaderHeight - closedHeaderHeight
    
    //MARK: - Variables
    private var isHeaderOpen = true

    //MARK: - IBOutlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var searchbarView: UIView!
    @IBOutlet weak var searchbarBackgroundView: UIView!
    @IBOutlet weak var searchbarStack: UIStackView!
    @IBOutlet weak var searchbarLabel: UILabel!
    @IBOutlet weak var searchbarIcon: UIImageView!
    @IBOutlet weak var searchbarLogoStack: UIStackView!
    @IBOutlet weak var logoStack: UIStackView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var seperatorView: UIView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setSearchBar()
        setupGestures()
        registerXib()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openHeaderView()
        tableView.separatorColor = .clear
    }
    
    //MARK: - Setup
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setSearchBar() {
        searchbarView.layer.cornerRadius = 20.0
    }
    
    private func setupGestures() {
        // searchbarTap
        let searchbarTap = UITapGestureRecognizer(target: self, action: #selector(searchbarViewTapped))
        searchbarView.addGestureRecognizer(searchbarTap)
        //
//        let
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "BannerCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BannerCell")
    }
    
    //MARK: - Gesture Actions
    @objc private func searchbarViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Search Bar Tapped")
    }
}

//MARK: - TableView

extension FrontViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell") as? BannerCell else {
                return UITableViewCell()
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Placeholder Cell") else {
                return UITableViewCell()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            return tableView.frame.width * 1.2
        case IndexPath(row: 0, section: 1):
            return 400
        default:
            return 100
        }
    }
    
    //MARK: - DidScroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        if offset < lowerLimit && !isHeaderOpen {
            openHeaderView()
            return
        }
        
        if offset > upperLimit && isHeaderOpen {
            closeHeaderView(offset)
            return
        }
        
        if offset < lowerLimit || offset > upperLimit {
            return
        }
        
        updateHeader(with: offset)
    }
    
    private func updateHeader(with offset: CGFloat) {
        updateBackgroundView(offset)
        updateHeaderHeight(offset)
        updateSeperator(offset)
    }
    
    private func updateHeaderHeight(_ offset: CGFloat) {
        headerHeight.constant = openHeaderHeight - offset
    }
    
    private func updateBackgroundView(_ offset: CGFloat) {
        let percentage: CGFloat = 1 - (offset / upperLimit)
        backgroundView.alpha = 1 * percentage
        logoStack.alpha = 1 * percentage
        buttonStack.alpha = 1 * percentage
        searchbarBackgroundView.alpha = 1 * (1 - percentage)
    }
    
    private func updateSeperator(_ offset: CGFloat) {
        if offset <= lowerLimit + (upperLimit / 2) {
            seperatorView.backgroundColor = .clear
        } else {
            seperatorView.backgroundColor = .opaqueSeparator.withAlphaComponent(0.5)
        }
    }
    
    private func openHeaderView() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            self.tableView.setContentOffset(.zero, animated: false)
            self.updateHeader(with: self.lowerLimit)
        })
    }
    
    private func closeHeaderView(_ offset: CGFloat) {
        if offset > upperLimit {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self = self else { return }
                self.updateHeader(with: self.upperLimit)
            })
        } else {
            tableView.setContentOffset(CGPoint(x: 0, y: upperLimit), animated: true)
        }
        isHeaderOpen = false
    }
    
    //MARK: - DidEnd
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapBack(scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        snapBack(scrollView.contentOffset.y)
    }
    
    private func snapBack(_ offSet: CGFloat) {
        if offSet > upperLimit / 2 {
            closeHeaderView(offSet)
        } else {
            openHeaderView()
        }
    }
    
}
