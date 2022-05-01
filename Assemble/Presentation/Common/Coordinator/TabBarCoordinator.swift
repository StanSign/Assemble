//
//  RootCoordinator.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/09.
//

import UIKit

//MARK: - Protocol

protocol TabBarCoordinator: Coordinator {
    var tabBarController: TabBarController { get set }
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

//MARK: - Class

final class DefaultTabBarCoordinator: NSObject, TabBarCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var tabBarController: TabBarController
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = TabBarController()
        super.init()
    }
    
    deinit {
        print("TabCoordinator deinit")
    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage(index: self.tabBarController.selectedIndex)
    }
    
    func selectPage(_ page: TabBarPage) {
        self.tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        self.tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map({ self.createTabNavController(of: $0) })
        self.configureTabBarController(with: controllers)
    }
    
    //MARK: - Create Tab Navigation Controller
    
    private func createTabNavController(of page: TabBarPage) -> UINavigationController {
        let tabNavController = UINavigationController()
        
        tabNavController.setNavigationBarHidden(false, animated: false)
        tabNavController.tabBarItem = self.configureTabBarItem(of: page)
        self.startTabCoordinator(of: page, to: tabNavController)
        
        return tabNavController
    }
    
    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        return UITabBarItem(
            title: nil,
            image: UIImage(named: page.pageIcon()),
            tag: page.pageOrderNumber()
        )
    }
    
    private func startTabCoordinator(of page: TabBarPage, to tabNavigationController: UINavigationController) {
        switch page {
        case .first:
            print("First Page Not Implemented Yet")
        case .home:
            let homeCoordinator = DefaultHomeCoordinator(tabNavigationController)
            homeCoordinator.finishDelegate = self
            self.childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .last:
            print("Last Page Not Implemented Yet")
        }
    }
    
    //MARK: - Configure Tab Bar Controller
    
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        let tabBar = self.tabBarController.tabBar
        tabBar.barTintColor = .black
        tabBar.tintColor = .white
        tabBar.standardAppearance.configureWithOpaqueBackground()
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }
}

//MARK: - Coordinator Finish Delegate

extension DefaultTabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        if childCoordinator.type == .home {
            navigationController.viewControllers.removeAll()
        } else if childCoordinator.type == .setup {
            self.navigationController.viewControllers.removeAll()
            self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        }
    }
}
