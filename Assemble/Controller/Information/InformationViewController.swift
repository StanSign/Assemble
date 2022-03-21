//
//  InformationViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/21.
//

import UIKit
import Kingfisher

class InformationViewController: UIViewController {
    
    //MARK: - Variables
    var isSwipeNotRecognized = true
    var id: Int?
    var type: AssembleAPIManager.contentType?

    //MARK: - IBOutlets
    @IBOutlet weak var backIcon: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var shareIcon: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var screenEdgePanRecognizer: UIScreenEdgePanGestureRecognizer!
    
    convenience init(id: Int, type: AssembleAPIManager.contentType) {
        self.init()
        self.id = id
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupEdgePanGesture()
        setupGradientLayer()
        setupGestures()
        
        AssembleAPIManager.shared.requestDetailInfo(id, type) { data in
            var imageString: String?
            var titleLabel: String?
            switch self.type {
            case .films:
                do {
                    let res = try JSONDecoder().decode(AssembleAPIManager.FilmResult.self, from: data)
                    imageString = res.results.first?.fImage
                    titleLabel = res.results.first?.fNM
                } catch { }
            case .tvSeries:
                print("TV Series")
            case .actors:
                do {
                    let res = try JSONDecoder().decode(AssembleAPIManager.ActorResult.self, from: data)
                    imageString = res.results.first?.aImage
                    titleLabel = res.results.first?.aNM ?? res.results.first?.aNM_en
                } catch { }
            case .characters:
                print("Character")
            default:
                print("Default")
            }
            AssembleAPIManager.shared.requestAndSetImage(to: self.imageView, with: imageString)
            self.headerTitleLabel.text = titleLabel
        }
    }
    
    private func setupEdgePanGesture() {
        screenEdgePanRecognizer.edges = .left
    }
    
    private func setupGestures() {
        let backIconTap = UITapGestureRecognizer(target: self, action: #selector(backIconTapped))
        backIcon.addGestureRecognizer(backIconTap)
        let shareIconTap = UITapGestureRecognizer(target: self, action: #selector(shareIconTapped))
        shareIcon.addGestureRecognizer(shareIconTap)
    }
    
    @objc private func backIconTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareIconTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Share Icon Tapped")
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0, 0.5, 0.7, 1]
        
        gradientContainerView.isUserInteractionEnabled = false
        gradientContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gradientContainerView.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = imageContainerView.bounds
    }
    
    @IBAction func screenEdgePanned(_ sender: Any) {
        if isSwipeNotRecognized {
            isSwipeNotRecognized = false
            self.navigationController?.popViewController(animated: true)
        }
    }
}
