//
//  AppCoordinator.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = self.navigationController
        let coordinator = IntroCoordinator(navigationController: navigationController)
        coordinator.start()
        
        window.makeKeyAndVisible()
    }
}
