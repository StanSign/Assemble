//
//  SearchCoordinator.swift
//  Assemble
//
//  Created by 이창준 on 2022/04/15.
//

import UIKit

protocol SearchCoordinator: Coordinator {
    
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
}
