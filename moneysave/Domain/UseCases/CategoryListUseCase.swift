//
//  CategoryListUseCase.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/20.
//

import RxSwift
import RxCocoa

protocol CategoryListUseCaseProtocol {
    
}

final class CategoryListUseCage: CategoryListUseCaseProtocol {
    private let categoryListRepository: CategoryListProtocol
    private let categoryDeleteRepository: CategoryDeleteProtocol
    private let categoryUpdateRepository: CategoryUpdateProtocol
    
    init(categoryListRepository: CategoryListProtocol,
         categoryDeleteRepository: CategoryDeleteProtocol,
         categoryUpdateRepository: CategoryUpdateProtocol) {
        self.categoryListRepository = categoryListRepository
        self.categoryDeleteRepository = categoryDeleteRepository
        self.categoryUpdateRepository = categoryUpdateRepository
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
    
    func categoryDeleteRequest(_ dto: CategoryDeleteDTO) -> Observable<CategoryDeleteModel> {
        return Observable.create { [weak self] observer in
            
            self?.categoryDeleteRepository.requestCategoryDelete(dto: dto, success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
    
    func categoryUpdateRequest(_ dto: CategoryUpdateDTO) -> Observable<CategoryUpdateModel> {
        return Observable.create { [weak self] observer in
            
            self?.categoryUpdateRepository.requestCategoryUpdate(dto: dto, success: { responseData in
                observer.onNext(responseData)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
}
