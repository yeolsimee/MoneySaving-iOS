//
//  RoutineUseCase.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/09.
//

import RxSwift
import RxCocoa

protocol RoutineUseCaseProtocol {
    
}

final class RoutineUseCase: RoutineUseCaseProtocol {
    private let categoryListRepository: CategoryListProtocol
    private let categoryInsertRepository: CategoryInsertProtocol
    private let routineCreateRepository: RoutineCreateProtocol
    private let routineUpdateRepository: RoutineUpdateProtocol
    
    init(categoryListRepository: CategoryListProtocol,
         categoryInsertRepository: CategoryInsertProtocol,
         routineCreateRepository: RoutineCreateProtocol,
         routineUpdateRepository: RoutineUpdateProtocol) {
        self.categoryListRepository = categoryListRepository
        self.categoryInsertRepository = categoryInsertRepository
        self.routineCreateRepository = routineCreateRepository
        self.routineUpdateRepository = routineUpdateRepository
    }
    
    func categoryListRequest() -> Observable<CategoryListModel> {
        return Observable.create { [weak self] observer in
            
            self?.categoryListRepository.requestCategoryList(success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
    
    func categoryInsertRequest(_ dto: CategoryInsertDTO) -> Observable<CategoryInsertModel> {
        return Observable.create { [weak self] observer in
            
            self?.categoryInsertRepository.requestCategoryInsert(dto: dto,
                                                               success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
    
    func routineCreateRequest(_ dto: RoutineCreateDTO) -> Observable<RoutineCreateModel> {
        return Observable.create { [weak self] observer in
            
            self?.routineCreateRepository.requestRoutineCreate(dto: dto,
                                                               success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
    
    func routineUpdateRequest(_ dto: RoutineUpdateDTO) -> Observable<RoutineUpdateModel> {
        return Observable.create { [weak self] observer in
            
            self?.routineUpdateRepository.requestRoutineUpdate(dto: dto,
                                                               success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
}
