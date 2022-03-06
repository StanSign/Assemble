//
//  SetupViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/02.
//

import UIKit
import SnapKit
import Hero
import Lottie
import RealmSwift

class SetupViewController: UIViewController {
    
    //MARK: - Constants
    let network = Network()
    let realm = try! Realm()
    
    //MARK: - Variables
    private var animationView: AnimationView?

    //MARK: - IBOutlets
    @IBOutlet weak var searchBarView: UIView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        loadingSpinner()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        network.getUpcomingData {
            self.openRootVC()
        }
    }
    
    //MARK: - Setup
    private func setupSearchBar() {
        searchBarView.layer.cornerRadius = 20.0
    }
    
    private func loadingSpinner() {
        animationView = .init(name: "Loader")
        animationView?.loopMode = .loop
        view.addSubview(animationView!)
        animationView?.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
        animationView?.play()
    }
    
    private func openRootVC() {
        guard let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "RootViewController") else {
            return
        }
        animationView?.stop()
        rootVC.modalPresentationStyle = .fullScreen
        rootVC.hero.isEnabled = true
        rootVC.hero.modalAnimationType = .fade
        self.present(rootVC, animated: true)
    }
}
