//
//  MainCoordinator.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/26.
//

import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
    }
    
    func start() {
        let view = MainViewController()
        view.viewModel = MainViewModel(coordinator: self)
        
        navigationController.pushViewController(view, animated: false)
    }
}

