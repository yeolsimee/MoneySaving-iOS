//
//  MainCoordinator.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/26.
//

import UIKit
import RxSwift
import RxCocoa

final class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let disposeBag = DisposeBag()
    private let navigationController: UINavigationController
    
    var parentCoordinator: LoginCoordinator?
    
    var reloadState: PublishRelay<Bool> = PublishRelay()
    //    var reloadState: Bool = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.navigationBar.isHidden = true
    }
    
    func start() {
        let view = MainViewController()
        view.viewModel = MainViewModel(coordinator: self,
                                       mainUseCase: MainUseCase(findRoutineDayRepository: FindRoutineDay(),
                                                                findAllRoutineDayRepository: FindAllRoutineDay(),
                                                                routineDeleteRepository: RoutineDelegate(),
                                                                routineGetRepository: RoutineGet(),
                                                                routineCheckRepository: RoutineCheck(),
                                                                routineAlarmListRepository: RoutineAlarmList(),
                                                                withDrawRepository: WithDraw(),
                                                                appleService: AppleService()))
        reloadState
            .subscribe(onNext: { (value) in
                view.viewModel.reloadState.accept(value)
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(view, animated: false)
    }
    
    func pushRoutine(title: String, data: RoutineGetModel?) {
        let coordinator = RoutineCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.title = title
        coordinator.data = data
        coordinator.start()
    }
    
    func pushCategoryList() {
        let coordinator = CategoryListCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func popView() {
        navigationController.popViewController(animated: true)
    }
    
    func dismissView() {
        parentCoordinator?.childRemove(self)
    }
    
    func childRemove(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
