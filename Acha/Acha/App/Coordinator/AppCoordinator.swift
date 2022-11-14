//
//  AppCoordinator.swift
//  Acha
//
//  Created by 배남석 on 2022/11/14.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    weak var delegate: ChildCoordinatorPopable?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // 로그인 여부 따라 로직 분리
        connectTabBar()
    }
    
    func connectAuth() {
        let coordinator = AuthCoordinator(navigationController: navigationController)
        coordinator.start()
        coordinator.delegate = self
        childCoordinators.append(coordinator)
    }
    
    func connectTabBar() {
        let coordinator = TabBarCoordinator(navigationController: navigationController)
        coordinator.start()
        coordinator.delegate = self
        childCoordinators.append(coordinator)
    }
}

extension AppCoordinator: ChildCoordinatorPopable {
    
    func didFinished(childCoordinator: Coordinator) {
        switch childCoordinator {
        case is AuthCoordinator:
            connectTabBar()
        case is TabBarCoordinator:
            connectAuth()
        default:
            break
        }
    }
}
