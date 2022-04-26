//
//  HomeCoordinator.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/11.
//

import UIKit

protocol HomeCoordinator: Coordinator {
    func showSearchFlow()
}

final class DefaultHomeCoordinator: HomeCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var homeViewController: HomeViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .home
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        self.homeViewController = homeVC
    }
    
    func start() {
        self.homeViewController.viewModel = HomeViewModel(
            coordinator: self,
            homeUseCase: DefaultHomeUseCase(bannerRepository: DefaultHomeBannerRepository())
        )
        self.navigationController.pushViewController(self.homeViewController, animated: true)
    }
    
    func showSearchFlow() {
        let searchCoordinator = DefaultSearchCoordinator(self.navigationController)
        searchCoordinator.finishDelegate = self
        self.childCoordinators.append(searchCoordinator)
        searchCoordinator.start()
    }
}

extension DefaultHomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popToRootViewController(animated: true) 
    }
}
