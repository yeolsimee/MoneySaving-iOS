//
//  IntroCoordinator.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/15.
//

import UIKit


final class IntroCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
    }
    
    func start() {
        let view = IntroViewController()
        view.viewModel = IntroViewModel(coordinator: self,
                                        introUseCase: IntroUseCase(emailRepository: LoginRepository()))
        navigationController.pushViewController(view, animated: false)
    }
    
    func pushToLogin() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushToMain() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
