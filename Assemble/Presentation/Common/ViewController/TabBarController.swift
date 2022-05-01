//
//  TabBarController.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/01.
//

import UIKit
import AVFoundation

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        DefaultHapticService.shared.impact(style: .light)
    }
}
