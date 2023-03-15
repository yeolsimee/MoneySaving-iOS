//
//  IntroViewModel.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import Foundation
import RxSwift
import RxCocoa


final class IntroViewModel {
    var coordinator: IntroCoordinator?
    
    init(coordinator: IntroCoordinator) {
        self.coordinator = coordinator
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }
    
    
}
