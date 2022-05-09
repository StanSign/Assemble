//
//  InfoCoordinator.swift
//  Assemble
//
//  Created by 이창준 on 2022/05/10.
//

import UIKit

protocol InfoCoordinator: Coordinator {
    
}

final class DefaultInfoCoordinator: InfoCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var infoViewController: InfoViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .info
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        let infoStoryboard = UIStoryboard(name: "Info", bundle: nil)
        let infoViewController = infoStoryboard.instantiateViewController(withIdentifier: "InfoVC") as! InfoViewController
        self.infoViewController = infoViewController
    }
    
    func start() {
        self.infoViewController.viewModel = InfoViewModel(
            coordinator: self,
            infoUseCase: DefaultInfoUseCase()
        )
        self.navigationController.pushViewController(self.infoViewController, animated: true)
    }
}

extension DefaultInfoCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popViewController(animated: true)
    }
}
