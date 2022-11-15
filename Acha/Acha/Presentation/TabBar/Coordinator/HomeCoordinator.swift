//
//  HomeCoordinator.swift
//  Acha
//
//  Created by 배남석 on 2022/11/14.
//

import UIKit 

protocol HomeCoordinatorProtocol: Coordinator {
    func showHomeViewController()
}

final class HomeCoordinator: HomeCoordinatorProtocol {
    var delegate: CoordinatorDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = false 
    }
    
    func start() {
        showHomeViewController()
    }
    
    func showHomeViewController() {
        let viewController = HomeViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
}