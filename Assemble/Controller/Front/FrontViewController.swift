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
    private let reuseIdentifier = "TestCell"
    private let headerIdentifier = "Header"
    
    //MARK: - Variables
    var headerView: HeaderView?
    private var headerHeight: CGFloat?

    //MARK: - IBOutlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topMenuView: UIView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var notifyIcon: UIImageView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeight = view.frame.width * 1.3
        setupCollectionView()
        setDelegates()
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Setup
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
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

//MARK: - CollectionView

extension FrontViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 180
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? HeaderView
        return headerView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: headerHeight!)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        return cell
    }
    
    //MARK: - DidScroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        
        if contentOffsetY < 0 {
            return
        }
        
        updateHeader(contentOffsetY)
    }
    
    private func updateHeader(_ contentOffsetY: CGFloat) {
        let percentage: CGFloat = 1 - (contentOffsetY / headerHeight!)
        
        updateHeaderIcon(percentage)
    }
    
    private func updateHeaderIcon(_ percentage: CGFloat) {
        switch percentage {
        case ..<0:
            topMenuView.alpha = 0
        case 0...0.25:
            topMenuView.alpha = 1 * (percentage / 0.25)
        case 0.25...:
            topMenuView.alpha = 1
        default:
            return
        }
    }
}

//MARK: - Collection View Delegate Flow Layout

extension FrontViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 50)
    }
}
