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
                                        introUseCase: IntroUseCase(googleService: GoogleService(),
                                                                   kakaoService: KakaoService(),
                                                                   naverService: NaverService(),
                                                                   appleService: AppleService()),
                                        presentingView: view)
        navigationController.pushViewController(view, animated: false)
    }
}
