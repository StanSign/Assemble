//
//  SecondaryViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/27.
//

import UIKit
import Hero
import RxSwift
import RxCocoa
import Kingfisher

class SecondaryViewController: UIViewController {
    
    //MARK: - Constants
    private let reuseIdentifier = "TestCell"
    private let headerIdentifier = "Header"
    
    private let numberOfCell = 4
    private let defaultHeight = 400.0
    
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
        registerXib()
    }
    
    private func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        registerXib()
    }
    
    private func registerXib() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        let heroCellNib = UINib(nibName: "HeroCell", bundle: nil)
        collectionView.register(heroCellNib, forCellWithReuseIdentifier: "HeroCell")
        
        let newsCellNib = UINib(nibName: "NewsCell", bundle: nil)
        collectionView.register(newsCellNib, forCellWithReuseIdentifier: "NewsCell")
        
        let placeholderCellNib = UINib(nibName: "PlaceHolderCell", bundle: nil)
        collectionView.register(placeholderCellNib, forCellWithReuseIdentifier: "PlaceHolderCell")
    }
    
    private func setupGestures() {
        let searchIconTap = UITapGestureRecognizer(target: self, action: #selector(searchIconTapped))
        searchIcon.addGestureRecognizer(searchIconTap)
        let notifyIconTap = UITapGestureRecognizer(target: self, action: #selector(notifyIconTapped))
        notifyIcon.addGestureRecognizer(notifyIconTap)
    }
    
    //MARK: - Gesture Actions
    @objc private func searchIconTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        searchIcon.hero.id = "searchIcon"
        let navController = self.parent?.parent?.navigationController
        
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC")
        searchVC.modalPresentationStyle = .fullScreen
        navController?.pushViewController(searchVC, animated: true)
    }
    
    @objc private func notifyIconTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        notifyIcon.hero.id = "notifyIcon"
        let navController = self.parent?.parent?.navigationController
        
        let storyboard = UIStoryboard(name: "Notification", bundle: nil)
        let notifyVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC")
        notifyVC.modalPresentationStyle = .fullScreen
        navController?.pushViewController(notifyVC, animated: true)
    }
}

//MARK: - CollectionView

extension SecondaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? HeaderView
        return headerView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: headerHeight!)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifierArray = FrontComposition.frontComposition.map { $0.typeOfCell }
        let defaultIdentifierArray: [FrontCell.CellType] = Array(repeating: FrontCell.CellType.PlaceHolderCell, count: numberOfCell - identifierArray.count)
        let identifierForIndexPath = (identifierArray + defaultIdentifierArray)[indexPath.row]
        
        var cell = UICollectionViewCell()
        switch identifierForIndexPath {
        case .HeroCell:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierForIndexPath.rawValue, for: indexPath) as! HeroCell
        case .NewsCell:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierForIndexPath.rawValue, for: indexPath) as! NewsCell
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierForIndexPath.rawValue, for: indexPath) as! PlaceHolderCell
        }
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

extension SecondaryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightArray = FrontComposition.frontComposition.map { $0.height }
        let defaultHeightArray: [CGFloat] = Array(repeating: defaultHeight, count: numberOfCell - heightArray.count)
        return .init(width: view.frame.width, height: (heightArray + defaultHeightArray)[indexPath.row])
    }
}
