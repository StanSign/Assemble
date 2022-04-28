//
//  SetupCoordinator.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/28.
//

import UIKit

protocol SetupCoordinator: Coordinator {
    func showMainFlow()
}

final class DefaultSetupCoordinator: SetupCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var setupViewController: SetupViewController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType { .setup }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
        self.setupViewController = SetupViewController()
    }
    
    func start() {
        print("I'm at Setup Flow")
        self.navigationController.pushViewController(self.setupViewController, animated: true)
        showMainFlow()
    }
    
    func showMainFlow() {
        let tabCoordinator = DefaultTabBarCoordinator.init(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

extension DefaultSetupCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        self.navigationController.viewControllers.removeAll()
    }
}
