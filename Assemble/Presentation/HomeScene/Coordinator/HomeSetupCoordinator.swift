//
//  SetupCoordinator.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/28.
//

import UIKit

protocol HomeSetupCoordinator: Coordinator {
    func showHomeFlow(with bannerData: [BannerData])
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
        self.homeSetupViewController.viewModel = HomeSetupViewModel(
            coordinator: self,
            homeUseCase: DefaultHomeUseCase(bannerRepository: DefaultHomeBannerRepository()))
        self.navigationController.pushViewController(self.homeSetupViewController, animated: true)
    }
    
    func showHomeFlow(with bannerData: [BannerData]) {
        let homeCoordinator = DefaultHomeCoordinator.init(self.navigationController)
        homeCoordinator.finishDelegate = self
        self.childCoordinators.append(homeCoordinator)
        homeCoordinator.pushHomeViewController(with: bannerData)
    }
}

extension DefaultHomeSetupCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        self.navigationController.viewControllers.removeAll()
    }
}
