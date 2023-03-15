//
//  IntroCoordinator.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
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
        view.viewModel = IntroViewModel()
        
        navigationController.pushViewController(view, animated: true)
    }
}
