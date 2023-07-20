//
//  CategoryListCoordinator.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/20.
//

import UIKit
import RxSwift
import RxCocoa

final class CategoryListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    var parentCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.navigationBar.isHidden = true
    }
    
    func start() {
        let view = CategoryListViewController()
        view.viewModel = CategoryListViewModel(coordinator: self,
                                               categoryListUseCase: CategoryListUseCage(categoryListRepository: CategoryList(),
                                                                                        categoryDeleteRepository: CategoryDelete(),
                                                                                        categoryUpdateRepository: CategoryUpdate()))
        navigationController.pushViewController(view, animated: true)
    }
    
    func popView() {
        navigationController.popViewController(animated: true)
    }
    
    func dismissView() {
        parentCoordinator?.childRemove(self)
    }
}
