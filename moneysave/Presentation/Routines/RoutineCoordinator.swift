//
//  RoutineCoordinator.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/28.
//

import UIKit
import RxSwift
import RxCocoa

final class RoutineCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    weak var parentCoordinator: MainCoordinator?
    
    var title: String?
    var data: RoutineGetModel?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
    }
    
    func start() {
        let view = RoutineViewController()
        view.viewModel = RoutineViewModel(coordinator: self,
                                          routineUseCase: RoutineUseCase(categoryListRepository: CategoryList(),
                                                                         categoryInsertRepository: CategoryInsert(),
                                                                         routineCreateRepository: RoutineCreate(),
                                                                         routineUpdateRepository: RoutineUpdate()))
        view.viewModel.title = title ?? ""
        view.viewModel.data = data
        navigationController.pushViewController(view, animated: true)
    }
    
    func popView() {
        navigationController.popViewController(animated: true)
    }
    
    func dismissView() {
        parentCoordinator?.reloadState.accept(true)
        parentCoordinator?.childRemove(self)
    }
}
