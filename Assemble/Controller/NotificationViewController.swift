//
//  NotificationViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/17.
//

import UIKit

class NotificationViewController: UIViewController {
    
    //MARK: - Variables
    @IBOutlet weak var backIcon: UIImageView!
    var isSwipeNotRecognized = true

    //MARK: - IBOutlets
    @IBOutlet var screenEdgePanRecognizer: UIScreenEdgePanGestureRecognizer!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupEdgePanGesture()
        setupGestures()
        
        
    }
    
    //MARK: - Setup
    
    private func setupEdgePanGesture() {
        screenEdgePanRecognizer.edges = .left
    }
    
    private func setupGestures() {
        let backIconTap = UITapGestureRecognizer(target: self, action: #selector(backIconTapped))
        backIcon.addGestureRecognizer(backIconTap)
    }

    @objc private func backIconTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func screenEdgePanned(_ sender: UIScreenEdgePanGestureRecognizer) {
        if isSwipeNotRecognized {
            isSwipeNotRecognized = false
            self.navigationController?.popViewController(animated: true)
        }
    }
}
