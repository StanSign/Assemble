//
//  SetupCoordinator.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/28.
//

import UIKit

protocol HomeSetupCoordinator: Coordinator {
    func showHomeFlow()
}

final class DefaultHomeSetupCoordinator: HomeSetupCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var homeSetupViewController: HomeSetupViewController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType { .setup }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
        self.homeSetupViewController = HomeSetupViewController()
    }
    
    func start() {
        print("I'm at Setup Flow")
        self.navigationController.pushViewController(self.homeSetupViewController, animated: true)
        showHomeFlow()
    }
    
    func showHomeFlow() {
        let homeCoordinator = DefaultHomeCoordinator.init(navigationController)
        homeCoordinator.finishDelegate = self
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)
    }
}

extension DefaultHomeSetupCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        self.navigationController.viewControllers.removeAll()
    }
}
