////
////  FrontViewController.swift
////  Assemble
////
////  Created by 이창준 on 2022/02/14.
////
//
//import UIKit
//
//class FrontViewController: UIViewController {

import UIKit

class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
//
//    //MARK: - Constants
//    let headerHeight: CGFloat = FrontViewConstants.headerHeight
//
//    let headerViewIdentifier: String = "ReusableHeader"
//
//    //MARK: - Variables
//
//    //MARK: - IBOutlets
//    @IBOutlet weak var backgroundView: UIView!
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    //MARK: - Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setDelegates()
//    }
//
//    //MARK: - Setup
//
//    private func setDelegates() {
//        collectionView.dataSource = self
//        collectionView.delegate = self
//    }
//
//    //MARK: - Gesture Actions
//
//}
//
////MARK: - CollectionView
//
//extension FrontViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 200
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceHolder", for: indexPath)
//        cell.backgroundColor = .blue
//        cell.layer.cornerRadius = 6.0
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewIdentifier, for: indexPath)
//            return headerView
//        default:
//            assert(false, "Unexpected Element Kind")
//        }
//    }
//
//}
//
////MARK: - CollectionView Delegate FlowLayout
//
//extension FrontViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let width: CGFloat = collectionView.frame.width
//        let height: CGFloat = headerHeight
//        return CGSize(width: width, height: height)
//    }
//}
