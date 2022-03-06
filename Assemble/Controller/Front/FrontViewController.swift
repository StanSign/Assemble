//
//  FrontViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/27.
//

import UIKit
import Lottie

class FrontViewController: UIViewController {
    
    //MARK: - Constants
    private let closedHeaderHeight: CGFloat = 0
    private let openHeaderHeight: CGFloat = 65
    private let lowerLimit: CGFloat = 0
    private let upperLimit: CGFloat = 65 // openHeaderHeight - closedHeaderHeight
    
    //MARK: - Variables
    private var isHeaderOpen = true

    //MARK: - IBOutlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var notifyIcon: UIImageView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
        setDelegates()
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
    
    private func registerXib() {
        let nibName = UINib(nibName: "BannerCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BannerCell")
    }
    
    private func setupGestures() {
        let searchIconTap = UITapGestureRecognizer(target: self, action: #selector(searchIconTapped))
        searchIcon.addGestureRecognizer(searchIconTap)
        let notifyIconTap = UITapGestureRecognizer(target: self, action: #selector(notifyIconTapped))
        notifyIcon.addGestureRecognizer(notifyIconTap)
    }
    
    //MARK: - Gesture Actions
    @objc private func searchIconTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Search Icon Tapped")
    }
    
    @objc private func notifyIconTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Notify Icon Tapped")
    }
}

//MARK: - TableView

extension FrontViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
            return tableView.frame.width * 1.4
        case IndexPath(row: 0, section: 1):
            return 400
        default:
            return 100
        }
    }
    
    //MARK: - DidScroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        updateHeader(with: offset)
    }
    
    private func updateHeader(with offset: CGFloat) {
        updateBackgroundView(offset)
    }
    
    private func updateBackgroundView(_ offset: CGFloat) {
        let percentage: CGFloat = 1 - (offset / upperLimit)
//        backgroundView.alpha = 1 * percentage
        buttonStack.alpha = 1 * percentage
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
    
}
