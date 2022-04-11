//
//  RootCoordinator.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/09.
//

import UIKit

protocol RootCoordinator: Coordinator {
    func showRootViewController()
}

final class DefaultRootCoordinator: RootCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showRootViewController()
    }
    
    func showRootViewController() {
        let rootVC: RootViewController = .init()
        navigationController.pushViewController(rootVC, animated: true)
    }
}
