//
//  LoginCoordinator.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/28.
//

import UIKit

final class LoginCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.navigationBar.isHidden = true
    }
    
    func start() {
        let view = LoginViewController()
        view.viewModel = LoginViewModel(coordinator: self,
                                        presentingView: view,
                                        loginUseCase: LoginUseCase(emailRepository: LoginRepository(),
                                                                   googleService: GoogleService(),
                                                                   kakaoService: KakaoService(),
                                                                   naverService: NaverService(),
                                                                   appleService: AppleService(),
                                                                   changeIsNewUserRepository: ChangeIsNewUser()))
        
        navigationController.pushViewController(view, animated: false)
        
    }
    
    func pushToMain() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
        
        print("2415 childCoordinators : \(childCoordinators)")
    }
    
    func childRemove(_ child: Coordinator?) {
        print("2415 child : \(child)")
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
        
        print("2415 childCoordinators2525 : \(childCoordinators)")
    }
}
