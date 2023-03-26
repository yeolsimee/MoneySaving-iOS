//
//  MainViewModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/03/26.
//

import RxSwift
import RxCocoa

final class MainViewModel {
    var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(form input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }
}
