//
//  RootViewController.swift
//  Assemble
//
//  Created by 이창준 on 2022/02/13.
//

import UIKit

import Tabman
import Pageboy

class RootViewController: TabmanViewController {
    
    enum Tab: String, CaseIterable {
        case detail // rawValue: detail
        case home
        case board
    }
    private let tabItems = Tab.allCases.map({ BarItem(for: $0) })
    private lazy var viewControllers = tabItems.compactMap({ $0.makeViewController() })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        dataSource = self
        isScrollEnabled = false
        
        // Create Bar
        addBar(MenuBar.make(), dataSource: self, at: .bottom)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension RootViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 1)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return tabItems[index]
    }
}

private class BarItem: TMBarItemable {
    
    let tab: RootViewController.Tab
    
    // initializer
    init(for tab: RootViewController.Tab) {
        self.tab = tab
    }
    
    private var _title: String? {
        return tab.rawValue.capitalized
    }
    var title: String? {
        get {
            return _title
        } set {}
    }
    
    private var _image: UIImage? {
        return UIImage(named: "ic_\(tab.rawValue)")
    }
    var image: UIImage? {
        get {
            return _image
        } set {}
    }
    
    var badgeValue: String?
    
    func makeViewController() -> UIViewController? {
        let storyboardName: String
        switch tab {
        case .detail:
            storyboardName = "Detail"
        case .home:
            storyboardName = "Home"
            let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
            let homeVC = storyBoard.instantiateInitialViewController() as! HomeViewController
            homeVC.viewModel = HomeViewModel(homeUseCase: DefaultHomeUseCase(bannerRepository: DefaultHomeBannerRepository()))
            return homeVC
        case .board:
            storyboardName = "Board"
        }
        
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()
    }
}
