//
//  SearchCoordinator.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/15.
//

import UIKit

protocol SearchCoordinator: Coordinator {
    func showInfoFlow(_ id: Int)
}

final class DefaultSearchCoordinator: SearchCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var searchViewController: SearchViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .search
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        let homeStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let searchVC = homeStoryboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
        self.searchViewController = searchVC
    }
    
    func start() {
        self.searchViewController.viewModel = SearchViewModel(
            coordinator: self,
            searchUseCase: DefaultSearchUseCase(searchRepository: DefaultSearchRepository()))
        self.navigationController.pushViewController(searchViewController, animated: true)
    }
    
    func showInfoFlow(_ id: Int) {
        let infoCoordinator = DefaultInfoCoordinator(self.navigationController)
        infoCoordinator.finishDelegate = self
        self.childCoordinators.append(infoCoordinator)
        infoCoordinator.start()
    }
    
    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension DefaultSearchCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        //
    }
}
