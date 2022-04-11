//
//  RootCoordinator.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/09.
//

import UIKit

//MARK: - Protocol

protocol TabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController { get set }
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

//MARK: - Class

final class DefaultTabBarCoordinator: NSObject, TabBarCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    var tabBarController: UITabBarController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
        super.init()
    }
    
    deinit {
        print("TabCoordinator deinit")
    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage.init(index: tabBarController.selectedIndex)
    }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map({ createTabNavController(of: $0) })
        configureTabBarController(with: controllers)
    }
    
    //MARK: - Create Tab Navigation Controller
    
    private func createTabNavController(of page: TabBarPage) -> UINavigationController {
        let tabNavController = UINavigationController()
        
        tabNavController.setNavigationBarHidden(false, animated: false)
        tabNavController.tabBarItem = configureTabBarItem(of: page)
        self.startTabCoordinator(of: page, to: tabNavController)
        
        return tabNavController
    }
    
    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        return UITabBarItem(
            title: nil,
            image: nil,
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
    
    private func configureTabBarController(with tabViewControllers: [UINavigationController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        self.tabBarController.tabBar.backgroundColor = .darkGray
        
        self.navigationController.pushViewController(tabBarController, animated: true)
    }
}

//MARK: - Coordinator Finish Delegate

extension DefaultTabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}
