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
    let realm = try! Realm()
    
    //MARK: - Variables
    private var animationView: AnimationView?

    //MARK: - IBOutlets
        //
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingSpinner()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        openRootVC()
//        network.getNews {
//            
//        }
//        network.getUpcomingData {
//            self.openRootVC()
//        }
    }
    
    //MARK: - Setup
    
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
        self.navigationController?.pushViewController(rootVC, animated: true)
    }
}
