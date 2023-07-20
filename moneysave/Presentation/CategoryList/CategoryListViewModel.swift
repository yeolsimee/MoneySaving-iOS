//
//  CategoryListViewModel.swift
//  moneysave
//
//  Created by Mingoo on 2023/05/20.
//

import RxSwift
import RxCocoa

final class CategoryListViewModel {
    var coordinator: CategoryListCoordinator?
    
    private let categoryListUseCase: CategoryListUseCage
    
    var isCategoryDelete: PublishRelay<String> = PublishRelay()
    var isCategoryUpdate: PublishRelay<CategoryListData> = PublishRelay()
    
    init(coordinator: CategoryListCoordinator,
         categoryListUseCase: CategoryListUseCage) {
        self.coordinator = coordinator
        self.categoryListUseCase = categoryListUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let btnBackDidTabEvent: Observable<Void>
    }
    
    struct Output {
        var categoryListData: PublishRelay<[CategoryListData]> = PublishRelay()
    }
    
    func transform(form input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.categoryListAPI(output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.btnBackDidTabEvent
            .withUnretained(self)
            .subscribe(onNext: { (view, _) in
                view.coordinator?.popView()
            })
            .disposed(by: disposeBag)
        
        isCategoryDelete
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                let dto = CategoryDeleteDTO(categoryId: value)
                view.categoryDeleteAPI(dto: dto, output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        isCategoryUpdate
            .withUnretained(self)
            .subscribe(onNext: { (view, value) in
                let dto = CategoryUpdateDTO(categoryId: value.categoryId ?? "", categoryName: value.categoryName)
                view.categoryUpdateAPI(dto: dto, output: output, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func dismissView() {
        coordinator?.dismissView()
    }
    
    func categoryListAPI(output: Output, disposeBag: DisposeBag) {
        categoryListUseCase.categoryListRequest()
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                if model.success {
                    output.categoryListData.accept(model.data)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func categoryDeleteAPI(dto: CategoryDeleteDTO, output: Output, disposeBag: DisposeBag) {
        categoryListUseCase.categoryDeleteRequest(dto)
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                if model.success {
                    view.categoryListAPI(output: output, disposeBag: disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func categoryUpdateAPI(dto: CategoryUpdateDTO, output: Output, disposeBag: DisposeBag) {
        categoryListUseCase.categoryUpdateRequest(dto)
            .withUnretained(self)
            .subscribe(onNext: { (view, model) in
                if model.success {
                    view.categoryListAPI(output: output, disposeBag: disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
}
