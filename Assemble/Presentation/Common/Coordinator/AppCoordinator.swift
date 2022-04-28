//
//  AppCoordinator.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/08.
//

import UIKit

protocol AppCoordinator: Coordinator {
    func showMainFlow()
    func showLoginFlow()
}

final class DefaultAppCoordinator: AppCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType { .app }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        showMainFlow()
    }
    
    func showLoginFlow() {
        
    }
    
    func showMainFlow() {
        let setupCoordinator = DefaultTabBarCoordinator.init(navigationController)
        setupCoordinator.finishDelegate = self
        setupCoordinator.start()
        childCoordinators.append(setupCoordinator)
    }
}

extension DefaultAppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        self.navigationController.viewControllers.removeAll()
        
        switch childCoordinator.type {
        case .tab:
            showLoginFlow()
        default:
            break
        }
    }
}
