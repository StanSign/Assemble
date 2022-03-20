//
//  InformationViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/03/21.
//

import UIKit

class InformationViewController: UIViewController {
    
    //MARK: - Variables
    var id: Int = -999

    //MARK: - IBOutlets
    @IBOutlet weak var textLabel: UILabel!
    
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        textLabel.text = "\(id)"
    }

}
